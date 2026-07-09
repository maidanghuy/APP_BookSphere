package com.booksphere.borrow.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Borrow item response")
public record BorrowItemResponse(
        @Schema(description = "Borrow item ID", example = "5001")
        Long id,
        @Schema(description = "Book ID", example = "1")
        Long bookId,
        @Schema(description = "Borrowed quantity", example = "1")
        Integer quantity,
        @Schema(description = "Borrow item status", example = "BORROWING")
        String status
) {
}
