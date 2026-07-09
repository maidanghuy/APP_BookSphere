package com.booksphere.fine.service.impl;

import com.booksphere.fine.config.UserContext;
import com.booksphere.fine.dto.request.FinePaymentRequest;
import com.booksphere.fine.dto.response.FinePaymentResponse;
import com.booksphere.fine.entity.Fine;
import com.booksphere.fine.entity.FinePayment;
import com.booksphere.fine.entity.enums.FinePaymentStatus;
import com.booksphere.fine.entity.enums.FineStatus;
import com.booksphere.fine.entity.enums.PaymentMethod;
import com.booksphere.fine.exception.BusinessException;
import com.booksphere.fine.mapper.FineMapper;
import com.booksphere.fine.repository.FinePaymentRepository;
import com.booksphere.fine.repository.FineRepository;
import com.booksphere.fine.service.FinePaymentService;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class FinePaymentServiceImpl implements FinePaymentService {

    private final FineRepository fineRepository;
    private final FinePaymentRepository finePaymentRepository;

    public FinePaymentServiceImpl(
            FineRepository fineRepository,
            FinePaymentRepository finePaymentRepository
    ) {
        this.fineRepository = fineRepository;
        this.finePaymentRepository = finePaymentRepository;
    }

    @Override
    @Transactional
    public FinePaymentResponse payFine(Long fineId, FinePaymentRequest request, UserContext userContext) {
        Fine fine = getFineOrThrow(fineId);
        requireFineAccess(fine, userContext);
        validateFinePayable(fine);

        PaymentMethod paymentMethod = parsePaymentMethod(request.getPaymentMethod());
        FinePaymentStatus paymentStatus = parsePaymentStatus(request.getPaymentStatus());
        BigDecimal paymentAmount = resolvePaymentAmount(request.getAmount(), fine.getAmount());

        FinePayment payment = new FinePayment();
        payment.setFine(fine);
        payment.setAmount(paymentAmount);
        payment.setPaymentMethod(paymentMethod.name());
        payment.setPaymentStatus(paymentStatus.name());
        payment.setPaidAt(LocalDateTime.now());

        FinePayment savedPayment = finePaymentRepository.save(payment);

        if (paymentStatus == FinePaymentStatus.SUCCESS) {
            fine.setStatus(FineStatus.PAID.name());
            fine.setPaidAt(LocalDateTime.now());
            fineRepository.save(fine);
        }

        return FineMapper.toPaymentResponse(savedPayment);
    }

    private Fine getFineOrThrow(Long fineId) {
        return fineRepository.findById(fineId)
                .orElseThrow(() -> new BusinessException(
                        "FINE_NOT_FOUND",
                        "Fine not found.",
                        HttpStatus.NOT_FOUND
                ));
    }

    private void requireFineAccess(Fine fine, UserContext userContext) {
        if (userContext.isMemberOnly() && !fine.getUserId().equals(userContext.userId())) {
            throw new BusinessException("FORBIDDEN", "Insufficient permissions.", HttpStatus.FORBIDDEN);
        }
    }

    private void validateFinePayable(Fine fine) {
        if (FineStatus.PAID.name().equals(fine.getStatus())) {
            throw new BusinessException(
                    "FINE_ALREADY_PAID",
                    "Fine has already been paid.",
                    HttpStatus.UNPROCESSABLE_ENTITY
            );
        }

        if (FineStatus.CANCELLED.name().equals(fine.getStatus())) {
            throw new BusinessException(
                    "FINE_CANCELLED",
                    "Fine has been cancelled.",
                    HttpStatus.UNPROCESSABLE_ENTITY
            );
        }
    }

    private BigDecimal resolvePaymentAmount(BigDecimal requestedAmount, BigDecimal fineAmount) {
        if (requestedAmount == null) {
            return fineAmount;
        }

        if (requestedAmount.compareTo(fineAmount) != 0) {
            throw new BusinessException(
                    "FINE_INVALID_AMOUNT",
                    "Payment amount must equal fine amount.",
                    HttpStatus.BAD_REQUEST
            );
        }

        return requestedAmount;
    }

    private PaymentMethod parsePaymentMethod(String paymentMethod) {
        if (paymentMethod == null || paymentMethod.isBlank()) {
            throw new BusinessException(
                    "VALIDATION_FAILED",
                    "paymentMethod is required.",
                    HttpStatus.BAD_REQUEST
            );
        }

        try {
            return PaymentMethod.valueOf(paymentMethod.trim().toUpperCase());
        } catch (IllegalArgumentException exception) {
            throw new BusinessException(
                    "VALIDATION_FAILED",
                    "Invalid payment method.",
                    HttpStatus.BAD_REQUEST
            );
        }
    }

    private FinePaymentStatus parsePaymentStatus(String paymentStatus) {
        if (paymentStatus == null || paymentStatus.isBlank()) {
            return FinePaymentStatus.SUCCESS;
        }

        try {
            return FinePaymentStatus.valueOf(paymentStatus.trim().toUpperCase());
        } catch (IllegalArgumentException exception) {
            throw new BusinessException(
                    "VALIDATION_FAILED",
                    "Invalid payment status.",
                    HttpStatus.BAD_REQUEST
            );
        }
    }
}
