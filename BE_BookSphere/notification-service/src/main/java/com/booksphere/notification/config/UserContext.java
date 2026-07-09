package com.booksphere.notification.config;

import com.booksphere.notification.exception.BusinessException;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.Set;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;

public record UserContext(
        Long userId,
        String username,
        String email,
        Set<String> roles
) {

    public static UserContext fromRequest(HttpServletRequest request) {
        String userIdHeader = request.getHeader(SecurityHeaderUtil.HEADER_USER_ID);
        if (userIdHeader == null || userIdHeader.isBlank()) {
            throw new BusinessException(
                    "AUTH_HEADER_MISSING",
                    "Missing user authentication headers.",
                    HttpStatus.UNAUTHORIZED
            );
        }

        String rolesHeader = request.getHeader(SecurityHeaderUtil.HEADER_USER_ROLE);
        Set<String> roles = rolesHeader == null || rolesHeader.isBlank()
                ? Set.of()
                : Arrays.stream(rolesHeader.split(","))
                        .map(String::trim)
                        .filter(role -> !role.isBlank())
                        .collect(Collectors.toSet());

        if (roles.isEmpty()) {
            throw new BusinessException(
                    "AUTH_HEADER_MISSING",
                    "Missing user role header.",
                    HttpStatus.UNAUTHORIZED
            );
        }

        return new UserContext(
                Long.valueOf(userIdHeader.trim()),
                request.getHeader(SecurityHeaderUtil.HEADER_USERNAME),
                request.getHeader(SecurityHeaderUtil.HEADER_USER_EMAIL),
                roles
        );
    }

    public boolean hasAnyRole(String... expectedRoles) {
        return Arrays.stream(expectedRoles).anyMatch(roles::contains);
    }

    public boolean isMemberOnly() {
        return roles.contains("MEMBER") && !hasAnyRole("ADMIN", "LIBRARIAN");
    }
}
