package com.booksphere.auth.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "Refresh token request")
public record RefreshTokenRequest(
        @NotBlank(message = "Refresh token is required.")
        @Schema(description = "Refresh token issued by login or registration", example = "eyJhbGciOiJIUzI1NiJ9.refresh")
        String refreshToken
) {
}
