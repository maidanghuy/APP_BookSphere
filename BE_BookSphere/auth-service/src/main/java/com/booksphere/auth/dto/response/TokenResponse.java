package com.booksphere.auth.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Token refresh response")
public record TokenResponse(
        @Schema(description = "New JWT access token", example = "eyJhbGciOiJIUzI1NiJ9.access")
        String accessToken,
        @Schema(description = "Token type", example = "Bearer")
        String tokenType,
        @Schema(description = "Access token lifetime in seconds", example = "900")
        long expiresIn
) {
}
