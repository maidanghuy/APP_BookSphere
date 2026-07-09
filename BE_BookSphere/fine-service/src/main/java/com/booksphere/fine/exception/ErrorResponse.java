package com.booksphere.fine.exception;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Error response item")
public record ErrorResponse(
        @Schema(description = "Machine-readable error code", example = "FINE_NOT_FOUND")
        String code,

        @Schema(description = "Human-readable error message", example = "Fine not found.")
        String message
) {
}
