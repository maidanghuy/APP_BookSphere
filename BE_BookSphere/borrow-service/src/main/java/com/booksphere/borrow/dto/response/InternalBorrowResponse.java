package com.booksphere.borrow.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;

@Schema(description = "Internal borrow snapshot response")
public record InternalBorrowResponse(
        @Schema(description = "Borrow ID", example = "1001")
        Long borrowId,
        @Schema(description = "User ID", example = "1")
        Long userId,
        @Schema(description = "Due date", example = "2026-07-21T17:00:00")
        LocalDateTime dueDate,
        @Schema(description = "Return date", example = "2026-07-20T10:30:00")
        LocalDateTime returnDate,
        @Schema(description = "Borrow status", example = "OVERDUE")
        String status
) {
}
