package com.booksphere.borrow.exception;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Error response item")
public record ErrorResponse(
        @Schema(description = "Machine-readable error code", example = "BORROW_NOT_FOUND")
        String code,

        @Schema(description = "Human-readable error message", example = "Borrow not found.")
        String message
) {
}
