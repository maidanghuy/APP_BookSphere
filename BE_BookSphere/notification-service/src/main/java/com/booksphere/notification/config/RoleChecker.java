package com.booksphere.notification.config;

import com.booksphere.notification.exception.BusinessException;
import org.springframework.http.HttpStatus;

public final class RoleChecker {

    private RoleChecker() {
    }

    public static void requireReadAccess(UserContext userContext) {
        if (!userContext.hasAnyRole("ADMIN", "LIBRARIAN", "MEMBER")) {
            throw new BusinessException("FORBIDDEN", "Insufficient permissions.", HttpStatus.FORBIDDEN);
        }
    }

    public static void requireWriteAccess(UserContext userContext) {
        if (!userContext.hasAnyRole("ADMIN", "LIBRARIAN", "MEMBER")) {
            throw new BusinessException("FORBIDDEN", "Insufficient permissions.", HttpStatus.FORBIDDEN);
        }
    }
}
