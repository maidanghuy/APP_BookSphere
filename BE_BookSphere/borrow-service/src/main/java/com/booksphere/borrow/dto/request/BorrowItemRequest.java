package com.booksphere.borrow.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

@Schema(description = "Borrow item request")
public record BorrowItemRequest(
        @NotNull(message = "Book ID is required.")
        @Schema(description = "Book ID", example = "1")
        Long bookId,

        @NotNull(message = "Quantity is required.")
        @Min(value = 1, message = "Quantity must be greater than 0.")
        @Schema(description = "Quantity to borrow", example = "1")
        Integer quantity
) {
}
