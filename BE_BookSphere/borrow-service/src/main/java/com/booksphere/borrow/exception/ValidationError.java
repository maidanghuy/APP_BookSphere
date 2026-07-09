package com.booksphere.borrow.exception;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Validation error item")
public record ValidationError(
        @Schema(description = "Invalid field name", example = "dueDate")
        String field,

        @Schema(description = "Machine-readable validation code", example = "VALIDATION_FAILED")
        String code,

        @Schema(description = "Validation message", example = "Due date is required.")
        String message
) {
}
