package com.booksphere.auth.exception;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Error response item")
public record ErrorResponse(
        @Schema(description = "Machine-readable error code", example = "AUTH_TOKEN_INVALID")
        String code,

        @Schema(description = "Human-readable error message", example = "Access token is expired or invalid.")
        String message
) {
}
