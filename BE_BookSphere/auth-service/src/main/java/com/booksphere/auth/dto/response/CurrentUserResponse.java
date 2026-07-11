package com.booksphere.auth.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "Current authenticated user response")
public record CurrentUserResponse(
        @Schema(description = "User ID", example = "1")
        Long id,

        @Schema(description = "Username", example = "member01")
        String username,

        @Schema(description = "Full name", example = "Nguyen Van A")
        String fullName,

        @Schema(description = "Email address", example = "member01@example.com")
        String email,

        @Schema(description = "Phone number", example = "0900000000")
        String phone,

        @Schema(description = "Primary role", example = "MEMBER")
        String role,

        @Schema(description = "Assigned roles", example = "[\"MEMBER\"]")
        List<String> roles,

        @Schema(description = "Whether the user account is active", example = "true")
        @JsonProperty("isActive")
        Boolean isActive
) {
}
