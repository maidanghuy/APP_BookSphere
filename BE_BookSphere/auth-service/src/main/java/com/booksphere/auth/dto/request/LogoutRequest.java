package com.booksphere.auth.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "Logout request")
public record LogoutRequest(
        @NotBlank(message = "Refresh token is required.")
        @Schema(description = "Refresh token to revoke", example = "eyJhbGciOiJIUzI1NiJ9.refresh")
        String refreshToken
) {
}
