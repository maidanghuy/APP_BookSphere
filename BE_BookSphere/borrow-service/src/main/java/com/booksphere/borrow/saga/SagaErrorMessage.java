package com.booksphere.borrow.saga;

import com.booksphere.borrow.exception.BusinessException;
import feign.FeignException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

final class SagaErrorMessage {

    private static final int MAX_MESSAGE_LENGTH = 200;
    private static final Pattern JSON_CODE_PATTERN = Pattern.compile("\"code\"\\s*:\\s*\"([^\"]+)\"");
    private static final Pattern JSON_MESSAGE_PATTERN = Pattern.compile("\"message\"\\s*:\\s*\"([^\"]+)\"");

    private SagaErrorMessage() {
    }

    static String business(BusinessException exception) {
        return compact(exception.getCode() + ": " + exception.getMessage());
    }

    static String rootCause(String context, Throwable exception) {
        Throwable rootCause = rootCause(exception);
        if (rootCause instanceof BusinessException businessException) {
            return compact(context + ": " + business(businessException));
        }

        if (rootCause instanceof FeignException feignException) {
            return feignRootCause(context, feignException);
        }

        String message = rootCause.getMessage();
        String summary = context + ": " + rootCause.getClass().getSimpleName();
        if (message != null && !message.isBlank()) {
            summary += ": " + firstLine(message);
        }

        return compact(summary);
    }

    static String append(String currentError, String nextError) {
        String next = compact(nextError);
        if (currentError == null || currentError.isBlank()) {
            return next;
        }

        String current = compact(currentError);
        int currentLimit = Math.max(40, MAX_MESSAGE_LENGTH - next.length() - 3);
        String combined = compact(current, currentLimit) + " | " + next;
        return compact(combined);
    }

    private static String feignRootCause(String context, FeignException exception) {
        StringBuilder summary = new StringBuilder(context)
                .append(": ")
                .append(exception.getClass().getSimpleName())
                .append(" status=")
                .append(exception.status());

        String responseBody = exception.contentUTF8();
        String code = jsonField(responseBody, JSON_CODE_PATTERN);
        String message = jsonField(responseBody, JSON_MESSAGE_PATTERN);

        if (code != null) {
            summary.append(" code=").append(code);
        }
        if (message != null) {
            summary.append(" message=").append(message);
        }

        return compact(summary.toString());
    }

    private static Throwable rootCause(Throwable exception) {
        Throwable current = exception;
        while (current.getCause() != null && current.getCause() != current) {
            current = current.getCause();
        }
        return current;
    }

    private static String jsonField(String responseBody, Pattern pattern) {
        if (responseBody == null || responseBody.isBlank()) {
            return null;
        }

        Matcher matcher = pattern.matcher(responseBody);
        return matcher.find() ? firstLine(matcher.group(1)) : null;
    }

    private static String firstLine(String value) {
        return value.replace('\n', ' ').replace('\r', ' ').trim();
    }

    private static String compact(String value) {
        return compact(value, MAX_MESSAGE_LENGTH);
    }

    private static String compact(String value, int maxLength) {
        String sanitized = value == null ? "" : firstLine(value).replaceAll("\\s+", " ");
        if (sanitized.length() <= maxLength) {
            return sanitized;
        }

        return sanitized.substring(0, Math.max(0, maxLength - 3)) + "...";
    }
}
