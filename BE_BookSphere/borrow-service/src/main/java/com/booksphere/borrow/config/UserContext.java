package com.booksphere.borrow.config;

import java.util.Arrays;
import java.util.Set;
import java.util.stream.Collectors;

public record UserContext(
        Long userId,
        String username,
        String email,
        Set<String> roles
) {

    public static UserContext fromHeaders(String userId, String username, String email, String rolesHeader) {
        Set<String> roles = rolesHeader == null || rolesHeader.isBlank()
                ? Set.of()
                : Arrays.stream(rolesHeader.split(","))
                        .map(String::trim)
                        .filter(role -> !role.isBlank())
                        .collect(Collectors.toSet());

        return new UserContext(Long.valueOf(userId), username, email, roles);
    }

    public boolean hasAnyRole(String... expectedRoles) {
        return Arrays.stream(expectedRoles).anyMatch(roles::contains);
    }

    public boolean isMemberOnly() {
        return roles.contains("MEMBER") && !hasAnyRole("ADMIN", "LIBRARIAN");
    }
}
