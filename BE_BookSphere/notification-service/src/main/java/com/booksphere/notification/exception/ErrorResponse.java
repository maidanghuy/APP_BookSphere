package com.booksphere.notification.exception;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Error response item")
public class ErrorResponse {

    @Schema(description = "Machine-readable error code", example = "NOTIFICATION_NOT_FOUND")
    private String code;
    @Schema(description = "Human-readable error message", example = "Notification not found.")
    private String message;

    public ErrorResponse() {
    }

    public ErrorResponse(String code, String message) {
        this.code = code;
        this.message = message;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
