package com.booksphere.notification.exception;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Validation error item")
public class ValidationError {

    @Schema(description = "Invalid field name", example = "title")
    private String field;
    @Schema(description = "Machine-readable validation code", example = "VALIDATION_FAILED")
    private String code;
    @Schema(description = "Validation message", example = "Title must not be blank.")
    private String message;

    public ValidationError(String field, String code, String message) {
        this.field = field;
        this.code = code;
        this.message = message;
    }

    public String getField() {
        return field;
    }

    public void setField(String field) {
        this.field = field;
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
