package com.booksphere.fine.service.impl;

import com.booksphere.fine.client.BorrowServiceClient;
import com.booksphere.fine.client.dto.ClientApiResponse;
import com.booksphere.fine.config.FineProperties;
import com.booksphere.fine.config.UserContext;
import com.booksphere.fine.dto.request.FineCreateRequest;
import com.booksphere.fine.dto.request.FineSearchRequest;
import com.booksphere.fine.dto.response.BorrowInternalResponse;
import com.booksphere.fine.dto.response.FineCreateResult;
import com.booksphere.fine.dto.response.FineResponse;
import com.booksphere.fine.dto.response.PageResponse;
import com.booksphere.fine.entity.Fine;
import com.booksphere.fine.entity.enums.FineCreatedFrom;
import com.booksphere.fine.entity.enums.FineStatus;
import com.booksphere.fine.exception.BusinessException;
import com.booksphere.fine.mapper.FineMapper;
import com.booksphere.fine.repository.FineRepository;
import com.booksphere.fine.service.FineService;
import feign.FeignException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Set;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class FineServiceImpl implements FineService {

    private static final Set<String> ALLOWED_SORT_FIELDS = Set.of("id", "createdAt", "amount", "status", "paidAt");

    private final FineRepository fineRepository;
    private final BorrowServiceClient borrowServiceClient;
    private final FineProperties fineProperties;

    public FineServiceImpl(
            FineRepository fineRepository,
            BorrowServiceClient borrowServiceClient,
            FineProperties fineProperties
    ) {
        this.fineRepository = fineRepository;
        this.borrowServiceClient = borrowServiceClient;
        this.fineProperties = fineProperties;
    }

    @Override
    @Transactional
    public FineCreateResult createFineInternal(FineCreateRequest request) {
        validateCreateRequest(request);

        return fineRepository.findByBorrowId(request.getBorrowId())
                .map(existing -> new FineCreateResult(FineMapper.toResponse(existing), false))
                .orElseGet(() -> new FineCreateResult(createNewFine(request), true));
    }

    @Override
    @Transactional(readOnly = true)
    public PageResponse<FineResponse> searchFines(FineSearchRequest request, UserContext userContext) {
        Long effectiveUserId = resolveSearchUserId(request.getUserId(), userContext);
        validateStatusFilter(request.getStatus());

        Pageable pageable = buildPageable(request);
        Page<Fine> finePage = fineRepository.search(
                effectiveUserId,
                request.getBorrowId(),
                normalizeStatus(request.getStatus()),
                pageable
        );

        PageResponse<FineResponse> response = new PageResponse<>();
        response.setContent(finePage.getContent().stream().map(FineMapper::toResponse).toList());
        response.setPage(finePage.getNumber());
        response.setSize(finePage.getSize());
        response.setTotalElements(finePage.getTotalElements());
        response.setTotalPages(finePage.getTotalPages());
        return response;
    }

    @Override
    @Transactional(readOnly = true)
    public FineResponse getFineById(Long fineId, UserContext userContext) {
        Fine fine = getFineOrThrow(fineId);
        requireFineAccess(fine, userContext);
        return FineMapper.toResponse(fine);
    }

    Fine getFineOrThrow(Long fineId) {
        return fineRepository.findById(fineId)
                .orElseThrow(() -> new BusinessException(
                        "FINE_NOT_FOUND",
                        "Fine not found.",
                        HttpStatus.NOT_FOUND
                ));
    }

    void requireFineAccess(Fine fine, UserContext userContext) {
        if (userContext.isMemberOnly() && !fine.getUserId().equals(userContext.userId())) {
            throw new BusinessException("FORBIDDEN", "Insufficient permissions.", HttpStatus.FORBIDDEN);
        }
    }

    private FineResponse createNewFine(FineCreateRequest request) {
        BorrowInternalResponse borrow = fetchBorrow(request.getBorrowId());
        validateBorrowEligibility(request, borrow);

        LocalDateTime dueDate = firstNonNull(request.getDueDate(), borrow.getDueDate());
        LocalDateTime returnDate = firstNonNull(request.getReturnDate(), borrow.getReturnDate());
        int daysOverdue = resolveDaysOverdue(request.getDaysOverdue(), dueDate, returnDate, request.getCreatedFrom());

        Fine fine = new Fine();
        fine.setUserId(firstNonNull(request.getUserId(), borrow.getUserId()));
        fine.setBorrowId(request.getBorrowId());
        fine.setAmount(calculateAmount(daysOverdue));
        fine.setCreatedFrom(request.getCreatedFrom().trim().toUpperCase());
        fine.setReason(resolveReason(request, daysOverdue));
        fine.setStatus(FineStatus.UNPAID.name());

        return FineMapper.toResponse(fineRepository.save(fine));
    }

    private BorrowInternalResponse fetchBorrow(Long borrowId) {
        try {
            ClientApiResponse<BorrowInternalResponse> response = borrowServiceClient.getInternalBorrow(borrowId);
            if (response == null || !response.isSuccess() || response.getData() == null) {
                throw new BusinessException(
                        "BORROW_NOT_FOUND",
                        "Borrow not found.",
                        HttpStatus.NOT_FOUND
                );
            }
            return response.getData();
        } catch (FeignException.NotFound exception) {
            throw new BusinessException(
                    "BORROW_NOT_FOUND",
                    "Borrow not found.",
                    HttpStatus.NOT_FOUND
            );
        } catch (FeignException exception) {
            throw new BusinessException(
                    "SERVICE_UNAVAILABLE",
                    "Borrow service is unavailable.",
                    HttpStatus.SERVICE_UNAVAILABLE
            );
        }
    }

    private void validateCreateRequest(FineCreateRequest request) {
        FineCreatedFrom createdFrom = parseCreatedFrom(request.getCreatedFrom());
        if (createdFrom == null) {
            throw new BusinessException(
                    "VALIDATION_FAILED",
                    "createdFrom must be OVERDUE_SCHEDULER or LATE_RETURN.",
                    HttpStatus.BAD_REQUEST
            );
        }
        request.setCreatedFrom(createdFrom.name());
    }

    private void validateBorrowEligibility(FineCreateRequest request, BorrowInternalResponse borrow) {
        FineCreatedFrom createdFrom = FineCreatedFrom.valueOf(request.getCreatedFrom());
        String status = borrow.getStatus() == null ? "" : borrow.getStatus().trim().toUpperCase();
        LocalDateTime dueDate = firstNonNull(request.getDueDate(), borrow.getDueDate());
        LocalDateTime returnDate = firstNonNull(request.getReturnDate(), borrow.getReturnDate());

        if (createdFrom == FineCreatedFrom.OVERDUE_SCHEDULER) {
            boolean overdue = "OVERDUE".equals(status)
                    || (dueDate != null && dueDate.isBefore(LocalDateTime.now()) && returnDate == null);
            if (!overdue) {
                throw new BusinessException(
                        "FINE_BORROW_NOT_ELIGIBLE",
                        "Borrow is not eligible for overdue fine creation.",
                        HttpStatus.UNPROCESSABLE_ENTITY
                );
            }
            return;
        }

        boolean lateReturn = "RETURNED".equals(status)
                && dueDate != null
                && returnDate != null
                && returnDate.isAfter(dueDate);
        if (!lateReturn) {
            throw new BusinessException(
                    "FINE_BORROW_NOT_ELIGIBLE",
                    "Borrow is not eligible for late return fine creation.",
                    HttpStatus.UNPROCESSABLE_ENTITY
            );
        }
    }

    private int resolveDaysOverdue(
            Integer requestDaysOverdue,
            LocalDateTime dueDate,
            LocalDateTime returnDate,
            String createdFrom
    ) {
        if (requestDaysOverdue != null && requestDaysOverdue > 0) {
            return requestDaysOverdue;
        }

        if (dueDate == null) {
            throw new BusinessException(
                    "VALIDATION_FAILED",
                    "dueDate is required to calculate overdue days.",
                    HttpStatus.BAD_REQUEST
            );
        }

        LocalDateTime endDate = returnDate != null
                ? returnDate
                : LocalDateTime.now();

        long days = ChronoUnit.DAYS.between(dueDate.toLocalDate(), endDate.toLocalDate());
        if (endDate.isAfter(dueDate) && days < 1) {
            days = 1;
        }
        if (days < 1) {
            throw new BusinessException(
                    "FINE_BORROW_NOT_ELIGIBLE",
                    "Borrow is not overdue.",
                    HttpStatus.UNPROCESSABLE_ENTITY
            );
        }

        return (int) days;
    }

    private BigDecimal calculateAmount(int daysOverdue) {
        return fineProperties.getAmountPerDay().multiply(BigDecimal.valueOf(daysOverdue));
    }

    private String resolveReason(FineCreateRequest request, int daysOverdue) {
        if (request.getReason() != null && !request.getReason().isBlank()) {
            return request.getReason().trim();
        }

        if (FineCreatedFrom.LATE_RETURN.name().equals(request.getCreatedFrom())) {
            return "Trả sách trễ " + daysOverdue + " ngày";
        }

        return "Phiếu mượn quá hạn " + daysOverdue + " ngày";
    }

    private Long resolveSearchUserId(Long requestedUserId, UserContext userContext) {
        if (userContext.isMemberOnly()) {
            return userContext.userId();
        }
        return requestedUserId;
    }

    private void validateStatusFilter(String status) {
        if (status == null || status.isBlank()) {
            return;
        }
        parseFineStatus(status);
    }

    private String normalizeStatus(String status) {
        if (status == null || status.isBlank()) {
            return null;
        }
        return parseFineStatus(status).name();
    }

    private FineStatus parseFineStatus(String status) {
        try {
            return FineStatus.valueOf(status.trim().toUpperCase());
        } catch (IllegalArgumentException exception) {
            throw new BusinessException(
                    "FINE_INVALID_STATUS",
                    "Invalid fine status.",
                    HttpStatus.BAD_REQUEST
            );
        }
    }

    private FineCreatedFrom parseCreatedFrom(String createdFrom) {
        if (createdFrom == null || createdFrom.isBlank()) {
            return null;
        }
        try {
            return FineCreatedFrom.valueOf(createdFrom.trim().toUpperCase());
        } catch (IllegalArgumentException exception) {
            return null;
        }
    }

    private Pageable buildPageable(FineSearchRequest request) {
        String sortField = ALLOWED_SORT_FIELDS.contains(request.getSortBy()) ? request.getSortBy() : "createdAt";
        Sort.Direction direction = "asc".equalsIgnoreCase(request.getSortDir())
                ? Sort.Direction.ASC
                : Sort.Direction.DESC;
        int page = Math.max(request.getPage(), 0);
        int size = request.getSize() > 0 ? request.getSize() : 10;
        return PageRequest.of(page, size, Sort.by(direction, sortField));
    }

    private <T> T firstNonNull(T primary, T fallback) {
        return primary != null ? primary : fallback;
    }
}
