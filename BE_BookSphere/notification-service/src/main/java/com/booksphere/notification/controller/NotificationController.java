package com.booksphere.notification.controller;

import com.booksphere.notification.config.OpenApiConfig;
import com.booksphere.notification.config.RoleChecker;
import com.booksphere.notification.config.UserContext;
import com.booksphere.notification.dto.request.NotificationSearchRequest;
import com.booksphere.notification.dto.response.ApiResponse;
import com.booksphere.notification.dto.response.NotificationResponse;
import com.booksphere.notification.dto.response.PageResponse;
import com.booksphere.notification.dto.response.ReadAllResponse;
import com.booksphere.notification.service.NotificationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/notifications")
@Tag(name = "Notifications", description = "APIs for viewing and marking notifications as read")
@SecurityRequirement(name = OpenApiConfig.SECURITY_SCHEME_NAME)
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @Operation(
            summary = "Get my notifications",
            description = "Get notifications for the authenticated user. Requires JWT through API Gateway, which forwards X-User-* headers."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Notifications retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request parameter"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT/user context"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Insufficient role"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping("/my")
    public ResponseEntity<ApiResponse<PageResponse<NotificationResponse>>> getMyNotifications(
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Boolean isRead,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir,
            HttpServletRequest request
    ) {
        UserContext userContext = UserContext.fromRequest(request);
        RoleChecker.requireReadAccess(userContext);

        NotificationSearchRequest searchRequest = buildSearchRequest(null, type, isRead, page, size, sortBy, sortDir);
        PageResponse<NotificationResponse> notifications = notificationService.searchMyNotifications(
                searchRequest,
                userContext
        );

        return ResponseEntity.ok(ApiResponse.success(
                "Notifications retrieved successfully.",
                notifications,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Search notifications",
            description = "Search notifications by user, type, and read status. Admin/librarian access may see broader results."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Notifications retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request parameter"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT/user context"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "User cannot view requested notifications"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<NotificationResponse>>> searchNotifications(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Boolean isRead,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir,
            HttpServletRequest request
    ) {
        UserContext userContext = UserContext.fromRequest(request);
        RoleChecker.requireReadAccess(userContext);

        NotificationSearchRequest searchRequest = buildSearchRequest(userId, type, isRead, page, size, sortBy, sortDir);
        PageResponse<NotificationResponse> notifications = notificationService.searchNotifications(
                searchRequest,
                userContext
        );

        return ResponseEntity.ok(ApiResponse.success(
                "Notifications retrieved successfully.",
                notifications,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Get notification detail",
            description = "Get a notification by ID. Normal users can only view their own notifications."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Notification retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT/user context"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "User cannot view this notification"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Notification not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping("/{notificationId}")
    public ResponseEntity<ApiResponse<NotificationResponse>> getNotificationById(
            @PathVariable Long notificationId,
            HttpServletRequest request
    ) {
        UserContext userContext = UserContext.fromRequest(request);
        RoleChecker.requireReadAccess(userContext);

        NotificationResponse notification = notificationService.getNotificationById(notificationId, userContext);
        return ResponseEntity.ok(ApiResponse.success(
                "Notification retrieved successfully.",
                notification,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Mark all notifications as read",
            description = "Mark all notifications for the authenticated user as read."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "All notifications marked as read"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT/user context"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Insufficient role"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @PutMapping("/read-all")
    public ResponseEntity<ApiResponse<ReadAllResponse>> markAllAsRead(HttpServletRequest request) {
        UserContext userContext = UserContext.fromRequest(request);
        RoleChecker.requireWriteAccess(userContext);

        ReadAllResponse result = notificationService.markAllAsRead(userContext);
        return ResponseEntity.ok(ApiResponse.success(
                "All notifications marked as read.",
                result,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Mark notification as read",
            description = "Mark a single notification as read. Normal users can only update their own notifications."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Notification marked as read"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT/user context"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "User cannot update this notification"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Notification not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @PutMapping("/{notificationId}/read")
    public ResponseEntity<ApiResponse<NotificationResponse>> markAsRead(
            @PathVariable Long notificationId,
            HttpServletRequest request
    ) {
        UserContext userContext = UserContext.fromRequest(request);
        RoleChecker.requireWriteAccess(userContext);

        NotificationResponse notification = notificationService.markAsRead(notificationId, userContext);
        return ResponseEntity.ok(ApiResponse.success(
                "Notification marked as read.",
                notification,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    private NotificationSearchRequest buildSearchRequest(
            Long userId,
            String type,
            Boolean isRead,
            int page,
            int size,
            String sortBy,
            String sortDir
    ) {
        NotificationSearchRequest searchRequest = new NotificationSearchRequest();
        searchRequest.setUserId(userId);
        searchRequest.setType(type);
        searchRequest.setIsRead(isRead);
        searchRequest.setPage(page);
        searchRequest.setSize(size);
        searchRequest.setSortBy(sortBy);
        searchRequest.setSortDir(sortDir);
        return searchRequest;
    }
}
