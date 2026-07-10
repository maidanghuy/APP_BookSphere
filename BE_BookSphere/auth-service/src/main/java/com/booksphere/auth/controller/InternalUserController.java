package com.booksphere.auth.controller;

import com.booksphere.auth.dto.response.ApiResponse;
import com.booksphere.auth.dto.response.InternalUserResponse;
import com.booksphere.auth.service.InternalUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/users")
@Tag(name = "Internal User APIs", description = "Internal APIs for service-to-service user snapshots.")
public class InternalUserController {

    private final InternalUserService internalUserService;

    public InternalUserController(InternalUserService internalUserService) {
        this.internalUserService = internalUserService;
    }

    @Operation(
            summary = "Get internal user snapshot",
            description = "Internal service-to-service API. Do not expose this endpoint to external clients through API Gateway."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "User retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "User not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping("/{userId}")
    public ResponseEntity<ApiResponse<InternalUserResponse>> getInternalUser(
            @PathVariable Long userId,
            HttpServletRequest request
    ) {
        InternalUserResponse user = internalUserService.getInternalUser(userId);
        return ResponseEntity.ok(ApiResponse.success(
                "User retrieved successfully.",
                user,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }
}
