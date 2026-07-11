package com.booksphere.borrow.saga;

import java.time.LocalDateTime;

public record FineCreationRequestedEvent(
        String sagaId,
        Long borrowId,
        Long userId,
        LocalDateTime dueDate,
        LocalDateTime effectiveDate,
        long daysOverdue,
        String createdFrom
) {
}
