package com.booksphere.borrow.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Borrow item response")
public record BorrowItemResponse(
        @Schema(description = "Borrow item ID", example = "5001")
        Long id,
        @Schema(description = "Book ID", example = "1")
        Long bookId,
        @Schema(description = "Book title snapshot", example = "Clean Code")
        String bookTitle,
        @Schema(description = "Book author snapshot", example = "Robert C. Martin")
        String bookAuthor,
        @Schema(description = "ISBN code", example = "9780132350884")
        String isbn,
        @Schema(description = "Borrowed quantity", example = "1")
        Integer quantity,
        @Schema(description = "Borrow item status", example = "BORROWING")
        String status
) {
}
