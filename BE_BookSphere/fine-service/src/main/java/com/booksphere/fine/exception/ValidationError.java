package com.booksphere.fine.exception;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Validation error item")
public record ValidationError(
        @Schema(description = "Invalid field name", example = "paymentMethod")
        String field,

        @Schema(description = "Machine-readable validation code", example = "VALIDATION_FAILED")
        String code,

        @Schema(description = "Validation message", example = "Payment method is required.")
        String message
) {
}
