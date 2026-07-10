package com.booksphere.auth.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Internal user snapshot response")
public record InternalUserResponse(
        @Schema(description = "User ID", example = "1")
        Long id,
        @Schema(description = "Full name", example = "Mai Dang Huy")
        String fullName,
        @Schema(description = "Username", example = "huy.member")
        String username,
        @Schema(description = "Email address", example = "huy.member@booksphere.local")
        String email,
        @Schema(description = "Whether the user account is active", example = "true")
        @JsonProperty("isActive")
        Boolean active
) {
}
