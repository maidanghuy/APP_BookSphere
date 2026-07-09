package com.booksphere.auth.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Authentication response containing user profile and issued tokens")
public record AuthResponse(
        @Schema(description = "Authenticated user profile")
        UserResponse user,
        @Schema(description = "JWT access token", example = "eyJhbGciOiJIUzI1NiJ9.access")
        String accessToken,
        @Schema(description = "Refresh token", example = "eyJhbGciOiJIUzI1NiJ9.refresh")
        String refreshToken,
        @Schema(description = "Token type", example = "Bearer")
        String tokenType,
        @Schema(description = "Access token lifetime in seconds", example = "900")
        long expiresIn
) {
}
