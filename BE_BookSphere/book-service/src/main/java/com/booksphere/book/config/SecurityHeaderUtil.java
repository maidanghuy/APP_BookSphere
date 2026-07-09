package com.booksphere.book.config;

import jakarta.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.List;

public final class SecurityHeaderUtil {

    public static final String HEADER_USER_ROLE = "X-User-Role";

    private SecurityHeaderUtil() {
    }

    public static List<String> getRoles(HttpServletRequest request) {
        String roleHeader = request.getHeader(HEADER_USER_ROLE);
        if (roleHeader == null || roleHeader.isBlank()) {
            return List.of();
        }

        return Arrays.stream(roleHeader.split(","))
                .map(String::trim)
                .filter(role -> !role.isEmpty())
                .toList();
    }
}
