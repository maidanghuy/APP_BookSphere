package com.booksphere.borrow.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.Instant;
import java.util.List;

@Schema(description = "Standard API response wrapper")
public class ApiResponse<T> {

    @Schema(description = "Whether the request completed successfully", example = "true")
    private boolean success;
    @Schema(description = "Human-readable response message", example = "Borrow retrieved successfully.")
    private String message;
    @Schema(description = "Response payload")
    private T data;
    @Schema(description = "Error details when success is false", nullable = true)
    private List<?> errors;
    @Schema(description = "Response timestamp", example = "2026-07-04T15:30:00Z")
    private Instant timestamp;
    @Schema(description = "Request path", example = "/api/borrows")
    private String path;
    @Schema(description = "HTTP status code", example = "200")
    private int status;

    public ApiResponse() {
        this.timestamp = Instant.now();
    }

    public ApiResponse(boolean success, String message, T data, List<?> errors, String path, int status) {
        this.success = success;
        this.message = message;
        this.data = data;
        this.errors = errors;
        this.timestamp = Instant.now();
        this.path = path;
        this.status = status;
    }

    public static <T> ApiResponse<T> success(String message, T data, String path, int status) {
        return new ApiResponse<>(true, message, data, null, path, status);
    }

    public static <T> ApiResponse<T> failure(String message, List<?> errors, String path, int status) {
        return new ApiResponse<>(false, message, null, errors, path, status);
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public List<?> getErrors() {
        return errors;
    }

    public void setErrors(List<?> errors) {
        this.errors = errors;
    }

    public Instant getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Instant timestamp) {
        this.timestamp = timestamp;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
