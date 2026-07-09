package com.booksphere.book.config;

import com.booksphere.book.exception.BusinessException;
import jakarta.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Set;
import org.springframework.http.HttpStatus;

public final class RoleChecker {

    private static final Set<String> WRITE_ROLES = Set.of("ADMIN", "LIBRARIAN");
    private static final Set<String> READ_ROLES = Set.of("ADMIN", "LIBRARIAN", "MEMBER");

    private RoleChecker() {
    }

    public static void requireWriteRole(HttpServletRequest request) {
        if (!hasAnyRole(request, WRITE_ROLES)) {
            throw new BusinessException("FORBIDDEN", "Insufficient permissions.", HttpStatus.FORBIDDEN);
        }
    }

    public static void requireReadRole(HttpServletRequest request) {
        if (!hasAnyRole(request, READ_ROLES)) {
            throw new BusinessException("FORBIDDEN", "Insufficient permissions.", HttpStatus.FORBIDDEN);
        }
    }

    private static boolean hasAnyRole(HttpServletRequest request, Set<String> allowedRoles) {
        List<String> roles = SecurityHeaderUtil.getRoles(request);
        return roles.stream().anyMatch(allowedRoles::contains);
    }
}
