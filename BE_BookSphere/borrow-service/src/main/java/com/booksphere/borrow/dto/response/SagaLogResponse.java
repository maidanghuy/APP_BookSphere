package com.booksphere.borrow.dto.response;

import java.time.LocalDateTime;

public record SagaLogResponse(
        Long id,
        String sagaId,
        Long borrowId,
        String transactionType,
        String currentStep,
        String status,
        String compensationAction,
        String errorMessage,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
}
