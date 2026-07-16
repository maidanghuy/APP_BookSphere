package com.booksphere.auth.exception;

import com.booksphere.auth.dto.response.ApiResponse;
import jakarta.servlet.http.HttpServletRequest;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusinessException(
            BusinessException exception,
            HttpServletRequest request
    ) {
        List<ErrorResponse> errors = List.of(new ErrorResponse(exception.getCode(), exception.getMessage()));
        ApiResponse<Void> response = ApiResponse.failure(
                exception.getMessage(),
                errors,
                request.getRequestURI(),
                exception.getStatus().value()
        );

        return ResponseEntity.status(exception.getStatus()).body(response);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Void>> handleValidationException(
            MethodArgumentNotValidException exception,
            HttpServletRequest request
    ) {
        List<ValidationError> errors = exception.getBindingResult()
                .getFieldErrors()
                .stream()
                .map(error -> new ValidationError(error.getField(), "VALIDATION_FAILED", error.getDefaultMessage()))
                .toList();

        ApiResponse<Void> response = ApiResponse.failure(
                "Validation failed.",
                errors,
                request.getRequestURI(),
                HttpStatus.BAD_REQUEST.value()
        );

        return ResponseEntity.badRequest().body(response);
    }

    @ExceptionHandler(Throwable.class)
    public ResponseEntity<ApiResponse<Void>> handleUnexpectedException(
            Throwable exception,
            HttpServletRequest request
    ) {
        exception.printStackTrace();
        List<ErrorResponse> errors = List.of(
                new ErrorResponse("INTERNAL_SERVER_ERROR", "Unexpected server error.")
        );
        ApiResponse<Void> response = ApiResponse.failure(
                "Unexpected server error.",
                errors,
                request.getRequestURI(),
                HttpStatus.INTERNAL_SERVER_ERROR.value()
        );

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }
}
