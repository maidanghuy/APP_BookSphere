package com.booksphere.gateway.dto;

import java.time.Instant;
import java.util.List;

public class ApiResponse<T> {

    private boolean success;
    private String message;
    private T data;
    private List<ErrorDetail> errors;
    private Instant timestamp;
    private String path;
    private int status;

    public ApiResponse() {
        this.timestamp = Instant.now();
    }

    public ApiResponse(
            boolean success,
            String message,
            T data,
            List<ErrorDetail> errors,
            String path,
            int status
    ) {
        this.success = success;
        this.message = message;
        this.data = data;
        this.errors = errors;
        this.timestamp = Instant.now();
        this.path = path;
        this.status = status;
    }

    public static <T> ApiResponse<T> failure(String message, List<ErrorDetail> errors, String path, int status) {
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

    public List<ErrorDetail> getErrors() {
        return errors;
    }

    public void setErrors(List<ErrorDetail> errors) {
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

    public record ErrorDetail(String code, String message) {
    }
}
