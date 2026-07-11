package com.booksphere.borrow.service.impl;

import com.booksphere.borrow.client.AuthServiceClient;
import com.booksphere.borrow.client.BookServiceClient;
import com.booksphere.borrow.client.dto.BookInternalResponse;
import com.booksphere.borrow.client.dto.ClientApiResponse;
import com.booksphere.borrow.client.dto.UserInternalResponse;
import com.booksphere.borrow.config.UserContext;
import com.booksphere.borrow.dto.request.BorrowCreateRequest;
import com.booksphere.borrow.dto.request.BorrowReturnRequest;
import com.booksphere.borrow.dto.request.BorrowSearchRequest;
import com.booksphere.borrow.dto.response.BorrowDetailResponse;
import com.booksphere.borrow.dto.response.BorrowResponse;
import com.booksphere.borrow.dto.response.InternalBorrowResponse;
import com.booksphere.borrow.dto.response.PageResponse;
import com.booksphere.borrow.entity.Borrow;
import com.booksphere.borrow.entity.BorrowItem;
import com.booksphere.borrow.entity.enums.BorrowStatus;
import com.booksphere.borrow.exception.BusinessException;
import com.booksphere.borrow.mapper.BorrowMapper;
import com.booksphere.borrow.repository.BorrowItemRepository;
import com.booksphere.borrow.repository.BorrowRepository;
import com.booksphere.borrow.saga.BorrowSagaOrchestrator;
import com.booksphere.borrow.service.BorrowService;
import jakarta.persistence.criteria.Predicate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BorrowServiceImpl implements BorrowService {

    private static final Logger log = LoggerFactory.getLogger(BorrowServiceImpl.class);
    private static final int MAX_PAGE_SIZE = 100;

    private final BorrowRepository borrowRepository;
    private final BorrowItemRepository borrowItemRepository;
    private final BookServiceClient bookServiceClient;
    private final AuthServiceClient authServiceClient;
    private final BorrowMapper borrowMapper;
    private final BorrowSagaOrchestrator borrowSagaOrchestrator;

    public BorrowServiceImpl(
            BorrowRepository borrowRepository,
            BorrowItemRepository borrowItemRepository,
            BookServiceClient bookServiceClient,
            AuthServiceClient authServiceClient,
            BorrowMapper borrowMapper,
            BorrowSagaOrchestrator borrowSagaOrchestrator
    ) {
        this.borrowRepository = borrowRepository;
        this.borrowItemRepository = borrowItemRepository;
        this.bookServiceClient = bookServiceClient;
        this.authServiceClient = authServiceClient;
        this.borrowMapper = borrowMapper;
        this.borrowSagaOrchestrator = borrowSagaOrchestrator;
    }

    @Override
    public BorrowDetailResponse createBorrow(BorrowCreateRequest request, UserContext userContext) {
        requireAuthenticated(userContext);
        validateBorrowRequest(request);
        BorrowDetailResponse createdBorrow = borrowSagaOrchestrator.borrowBooks(request, userContext);
        return buildDetailResponse(createdBorrow.id(), userContext);
    }

    @Override
    @Transactional(noRollbackFor = BusinessException.class)
    public BorrowDetailResponse returnBorrow(Long borrowId, BorrowReturnRequest request, UserContext userContext) {
        requireAuthenticated(userContext);
        Borrow borrow = getBorrowEntity(borrowId);
        requireBorrowAccess(borrow, userContext);
        borrowSagaOrchestrator.returnBooks(borrow, request);
        return buildDetailResponse(borrowId, userContext);
    }

    @Override
    @Transactional(readOnly = true)
    public PageResponse<BorrowResponse> searchBorrows(BorrowSearchRequest request, UserContext userContext) {
        requireAuthenticated(userContext);

        int page = Math.max(request.page(), 0);
        int size = Math.min(Math.max(request.size(), 1), MAX_PAGE_SIZE);
        Sort.Direction direction = "asc".equalsIgnoreCase(request.sortDir()) ? Sort.Direction.ASC : Sort.Direction.DESC;
        String sortBy = safeSortBy(request.sortBy());
        Pageable pageable = PageRequest.of(page, size, Sort.by(direction, sortBy));

        Page<Borrow> borrows = borrowRepository.findAll(buildSpecification(request, userContext), pageable);
        List<Long> borrowIds = borrows.getContent().stream()
                .map(Borrow::getId)
                .toList();
        Map<Long, List<BorrowItem>> itemsByBorrowId = borrowIds.isEmpty()
                ? Map.of()
                : borrowItemRepository.findByBorrow_IdIn(borrowIds)
                        .stream()
                        .collect(Collectors.groupingBy(item -> item.getBorrow().getId()));
        Map<Long, UserInternalResponse> usersById = loadUsersById(
                borrows.getContent().stream().map(Borrow::getUserId).collect(Collectors.toSet()),
                userContext
        );
        List<BorrowResponse> content = borrows.getContent().stream()
                .map(borrow -> borrowMapper.toResponse(
                        borrow,
                        totalItems(itemsByBorrowId.getOrDefault(borrow.getId(), List.of())),
                        usersById.get(borrow.getUserId())
                ))
                .toList();

        return new PageResponse<>(
                content,
                borrows.getNumber(),
                borrows.getSize(),
                borrows.getTotalElements(),
                borrows.getTotalPages(),
                borrows.isLast()
        );
    }

    @Override
    @Transactional(readOnly = true)
    public BorrowDetailResponse getBorrow(Long borrowId, UserContext userContext) {
        requireAuthenticated(userContext);
        return buildDetailResponse(borrowId, userContext);
    }

    @Override
    @Transactional(readOnly = true)
    public InternalBorrowResponse getInternalBorrow(Long borrowId) {
        return borrowMapper.toInternalResponse(getBorrowEntity(borrowId));
    }

    private void validateBorrowRequest(BorrowCreateRequest request) {
        if (request.dueDate() == null || !request.dueDate().isAfter(LocalDateTime.now())) {
            throw new BusinessException(
                    "BORROW_INVALID_DUE_DATE",
                    "Due date must be in the future.",
                    HttpStatus.BAD_REQUEST
            );
        }

        if (request.items() == null || request.items().isEmpty()) {
            throw new BusinessException("BORROW_ITEM_EMPTY", "Borrow items must not be empty.", HttpStatus.BAD_REQUEST);
        }

        boolean invalidQuantity = request.items().stream()
                .anyMatch(item -> item.quantity() == null || item.quantity() <= 0);
        if (invalidQuantity) {
            throw new BusinessException(
                    "BORROW_ITEM_INVALID_QUANTITY",
                    "Borrow item quantity must be greater than 0.",
                    HttpStatus.BAD_REQUEST
            );
        }
    }

    private Borrow getBorrowEntity(Long borrowId) {
        return borrowRepository.findById(borrowId)
                .orElseThrow(() -> new BusinessException(
                        "BORROW_NOT_FOUND",
                        "Borrow not found.",
                        HttpStatus.NOT_FOUND
                ));
    }

    private BorrowDetailResponse buildDetailResponse(Long borrowId, UserContext userContext) {
        Borrow borrow = getBorrowEntity(borrowId);
        requireBorrowAccess(borrow, userContext);

        List<BorrowItem> items = borrowItemRepository.findByBorrow_Id(borrow.getId());
        Map<Long, BookInternalResponse> booksById = loadBooksById(
                items.stream().map(BorrowItem::getBookId).collect(Collectors.toSet())
        );
        UserInternalResponse user = loadUserById(borrow.getUserId(), userContext);

        return borrowMapper.toDetailResponse(borrow, items, user, booksById);
    }

    private Map<Long, BookInternalResponse> loadBooksById(Set<Long> bookIds) {
        Map<Long, BookInternalResponse> booksById = new HashMap<>();
        for (Long bookId : bookIds) {
            try {
                ClientApiResponse<BookInternalResponse> response = bookServiceClient.getInternalBook(bookId);
                if (response != null && response.getData() != null) {
                    booksById.put(bookId, response.getData());
                }
            } catch (Exception exception) {
                log.warn("Book Service metadata lookup failed for bookId={}", bookId, exception);
            }
        }
        return booksById;
    }

    private Map<Long, UserInternalResponse> loadUsersById(Set<Long> userIds, UserContext userContext) {
        Map<Long, UserInternalResponse> usersById = new HashMap<>();
        for (Long userId : userIds) {
            UserInternalResponse user = loadUserById(userId, userContext);
            if (user != null) {
                usersById.put(userId, user);
            }
        }
        return usersById;
    }

    private UserInternalResponse loadUserById(Long userId, UserContext userContext) {
        try {
            ClientApiResponse<UserInternalResponse> response = authServiceClient.getInternalUser(userId);
            if (response != null && response.getData() != null) {
                return response.getData();
            }
        } catch (Exception exception) {
            log.warn("Auth Service user lookup failed for userId={}", userId, exception);
        }
        return fallbackCurrentUser(userId, userContext);
    }

    private UserInternalResponse fallbackCurrentUser(Long userId, UserContext userContext) {
        if (userContext == null || !userId.equals(userContext.userId())) {
            return null;
        }

        UserInternalResponse user = new UserInternalResponse();
        user.setId(userContext.userId());
        user.setUsername(userContext.username());
        user.setFullName(userContext.username());
        user.setEmail(userContext.email());
        user.setIsActive(true);
        return user;
    }

    private Integer totalItems(List<BorrowItem> items) {
        return items.stream()
                .map(BorrowItem::getQuantity)
                .filter(quantity -> quantity != null)
                .mapToInt(Integer::intValue)
                .sum();
    }

    private void requireAuthenticated(UserContext userContext) {
        if (userContext == null || userContext.userId() == null) {
            throw new BusinessException("AUTH_TOKEN_MISSING", "Missing user context.", HttpStatus.UNAUTHORIZED);
        }
    }

    private void requireBorrowAccess(Borrow borrow, UserContext userContext) {
        if (userContext.hasAnyRole("ADMIN", "LIBRARIAN")) {
            return;
        }

        if (userContext.isMemberOnly() && borrow.getUserId().equals(userContext.userId())) {
            return;
        }

        throw new BusinessException("FORBIDDEN", "You do not have permission to access this borrow.", HttpStatus.FORBIDDEN);
    }

    private Specification<Borrow> buildSpecification(BorrowSearchRequest request, UserContext userContext) {
        return (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (userContext.hasAnyRole("ADMIN", "LIBRARIAN")) {
                if (request.userId() != null) {
                    predicates.add(criteriaBuilder.equal(root.get("userId"), request.userId()));
                }
            } else if (userContext.isMemberOnly()) {
                predicates.add(criteriaBuilder.equal(root.get("userId"), userContext.userId()));
            } else {
                throw new BusinessException("FORBIDDEN", "You do not have permission to search borrows.", HttpStatus.FORBIDDEN);
            }

            BorrowStatus status = request.status();
            if (status != null) {
                predicates.add(criteriaBuilder.equal(root.get("status"), status));
            }
            if (request.fromDate() != null) {
                predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("borrowDate"), request.fromDate()));
            }
            if (request.toDate() != null) {
                predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("borrowDate"), request.toDate()));
            }

            return criteriaBuilder.and(predicates.toArray(Predicate[]::new));
        };
    }

    private String safeSortBy(String sortBy) {
        return switch (sortBy == null ? "" : sortBy) {
            case "id", "userId", "borrowDate", "dueDate", "returnDate", "status", "createdAt", "updatedAt" -> sortBy;
            default -> "createdAt";
        };
    }
}
