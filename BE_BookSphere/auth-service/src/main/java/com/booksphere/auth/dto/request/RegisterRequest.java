package com.booksphere.auth.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Schema(description = "Register request")
public record RegisterRequest(
        @NotBlank(message = "Full name is required.")
        @Size(max = 100, message = "Full name must not exceed 100 characters.")
        @Schema(description = "User full name", example = "Mai Dang Huy")
        String fullName,

        @NotBlank(message = "Username is required.")
        @Size(max = 50, message = "Username must not exceed 50 characters.")
        @Schema(description = "Unique username", example = "maidanghuy")
        String username,

        @NotBlank(message = "Email is required.")
        @Email(message = "Email must be valid.")
        @Size(max = 100, message = "Email must not exceed 100 characters.")
        @Schema(description = "User email address", example = "huy@example.com")
        String email,

        @NotBlank(message = "Password is required.")
        @Size(min = 2, message = "Password must be at least 2 characters.")
        @Schema(description = "Account password", example = "@1")
        String password,

        @Size(max = 20, message = "Phone must not exceed 20 characters.")
        @Schema(description = "Phone number", example = "0901234567")
        String phone
) {
}
