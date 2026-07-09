package com.booksphere.auth.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "User response")
public record UserResponse(
        @Schema(description = "User ID", example = "1")
        Long id,
        @Schema(description = "Full name", example = "System Administrator")
        String fullName,
        @Schema(description = "Username", example = "adminsys")
        String username,
        @Schema(description = "Email address", example = "admin@booksphere.local")
        String email,
        @Schema(description = "Phone number", example = "0901234567")
        String phone,
        @Schema(description = "Assigned roles", example = "[\"ADMIN\"]")
        List<String> roles,
        @Schema(description = "Whether the user account is active", example = "true")
        @JsonProperty("isActive")
        Boolean active
) {
}
