package com.booksphere.fine.config;

import jakarta.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.List;

public final class SecurityHeaderUtil {

    public static final String HEADER_USER_ID = "X-User-Id";
    public static final String HEADER_USERNAME = "X-Username";
    public static final String HEADER_USER_EMAIL = "X-User-Email";
    public static final String HEADER_USER_ROLE = "X-User-Role";

    private SecurityHeaderUtil() {
    }

    public static Long getUserId(HttpServletRequest request) {
        String userId = request.getHeader(HEADER_USER_ID);
        if (userId == null || userId.isBlank()) {
            return null;
        }
        return Long.valueOf(userId.trim());
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
