package com.booksphere.borrow.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "Borrow detail response")
public record BorrowDetailResponse(
        @Schema(description = "Borrow ID", example = "1001")
        Long id,
        @Schema(description = "User ID", example = "1")
        Long userId,
        @Schema(description = "Username of the borrowing member", example = "huy.member")
        String username,
        @Schema(description = "Display name of the borrowing member", example = "Mai Dang Huy")
        String memberName,
        @Schema(description = "Total borrowed book quantity in this borrow", example = "3")
        Integer totalItems,
        @Schema(description = "Borrow creation date", example = "2026-07-07T09:00:00")
        LocalDateTime borrowDate,
        @Schema(description = "Due date", example = "2026-07-21T17:00:00")
        LocalDateTime dueDate,
        @Schema(description = "Return date", example = "2026-07-20T10:30:00")
        LocalDateTime returnDate,
        @Schema(description = "Borrow status", example = "BORROWING")
        String status,
        @Schema(description = "Borrowed items")
        List<BorrowItemResponse> items
) {
}
