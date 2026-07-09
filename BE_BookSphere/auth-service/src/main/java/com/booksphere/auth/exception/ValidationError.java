package com.booksphere.auth.exception;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Validation error item")
public record ValidationError(
        @Schema(description = "Invalid field name", example = "username")
        String field,

        @Schema(description = "Machine-readable validation code", example = "VALIDATION_FAILED")
        String code,

        @Schema(description = "Validation message", example = "Username is required.")
        String message
) {
}
