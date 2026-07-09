package com.booksphere.fine.config;

import com.booksphere.fine.exception.BusinessException;
import org.springframework.http.HttpStatus;

public final class RoleChecker {

    private RoleChecker() {
    }

    public static void requireReadAccess(UserContext userContext) {
        if (!userContext.hasAnyRole("ADMIN", "LIBRARIAN", "MEMBER")) {
            throw new BusinessException("FORBIDDEN", "Insufficient permissions.", HttpStatus.FORBIDDEN);
        }
    }

    public static void requirePaymentAccess(UserContext userContext) {
        if (!userContext.hasAnyRole("ADMIN", "LIBRARIAN", "MEMBER")) {
            throw new BusinessException("FORBIDDEN", "Insufficient permissions.", HttpStatus.FORBIDDEN);
        }
    }
}
