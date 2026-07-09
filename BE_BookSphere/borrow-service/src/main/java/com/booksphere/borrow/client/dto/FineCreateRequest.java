package com.booksphere.borrow.client.dto;

import java.time.LocalDateTime;

public record FineCreateRequest(
        Long borrowId,
        Long userId,
        LocalDateTime dueDate,
        LocalDateTime returnDate,
        long daysOverdue,
        String createdFrom
) {
}
