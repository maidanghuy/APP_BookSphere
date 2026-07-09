package com.booksphere.notification.controller;

import com.booksphere.notification.dto.request.NotificationCreateRequest;
import com.booksphere.notification.dto.response.ApiResponse;
import com.booksphere.notification.dto.response.NotificationCreateResult;
import com.booksphere.notification.dto.response.NotificationResponse;
import com.booksphere.notification.service.NotificationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/notifications")
@Tag(name = "Internal Notification APIs", description = "Internal APIs for idempotent notification creation")
public class InternalNotificationController {

    private final NotificationService notificationService;

    public InternalNotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @Operation(
            summary = "Create notification idempotently",
            description = "Internal service-to-service API. Do not expose this endpoint to external clients through API Gateway."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Notification created successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Notification already exists"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request body"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Notification creation conflict"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @PostMapping
    public ResponseEntity<ApiResponse<NotificationResponse>> createNotification(
            @Valid @RequestBody NotificationCreateRequest body,
            HttpServletRequest request
    ) {
        NotificationCreateResult result = notificationService.createNotificationInternal(body);
        HttpStatus status = result.isCreated() ? HttpStatus.CREATED : HttpStatus.OK;
        String message = result.isCreated()
                ? "Notification created successfully."
                : "Notification already exists.";

        return ResponseEntity.status(status).body(ApiResponse.success(
                message,
                result.getNotification(),
                request.getRequestURI(),
                status.value()
        ));
    }
}
