package com.booksphere.borrow.dto.request;

import com.booksphere.borrow.entity.enums.BorrowStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;

@Schema(description = "Borrow search criteria")
public record BorrowSearchRequest(
        @Schema(description = "User ID filter", example = "1")
        Long userId,
        @Schema(description = "Borrow status filter", example = "BORROWING")
        BorrowStatus status,
        @Schema(description = "Start date filter", example = "2026-07-01T00:00:00")
        LocalDateTime fromDate,
        @Schema(description = "End date filter", example = "2026-07-31T23:59:59")
        LocalDateTime toDate,
        @Schema(description = "Zero-based page index", example = "0")
        int page,
        @Schema(description = "Page size", example = "10")
        int size,
        @Schema(description = "Sort field", example = "createdAt")
        String sortBy,
        @Schema(description = "Sort direction", example = "desc")
        String sortDir
) {
}
