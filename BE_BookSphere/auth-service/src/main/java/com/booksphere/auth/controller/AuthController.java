package com.booksphere.auth.controller;

import com.booksphere.auth.dto.request.LoginRequest;
import com.booksphere.auth.dto.request.LogoutRequest;
import com.booksphere.auth.dto.request.RefreshTokenRequest;
import com.booksphere.auth.dto.request.RegisterRequest;
import com.booksphere.auth.dto.response.ApiResponse;
import com.booksphere.auth.dto.response.AuthResponse;
import com.booksphere.auth.dto.response.CurrentUserResponse;
import com.booksphere.auth.dto.response.TokenResponse;
import com.booksphere.auth.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
@Tag(name = "Auth", description = "APIs for registration, login, refresh token and logout")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @Operation(
            summary = "Register a new user",
            description = "Create a BookSphere user account and return user profile plus access and refresh tokens. No JWT token is required."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Register successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request body"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Username or email already exists"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @PostMapping("/register")
    public ResponseEntity<ApiResponse<AuthResponse>> register(
            @Valid @RequestBody RegisterRequest request,
            HttpServletRequest servletRequest
    ) {
        AuthResponse authResponse = authService.register(request);
        ApiResponse<AuthResponse> response = ApiResponse.success(
                "Register successfully.",
                authResponse,
                servletRequest.getRequestURI(),
                HttpStatus.CREATED.value()
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @Operation(
            summary = "Login",
            description = "Authenticate a user by username and password, then return access token and refresh token. No JWT token is required."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Login successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request body"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Invalid username or password"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Account is inactive"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthResponse>> login(
            @Valid @RequestBody LoginRequest request,
            HttpServletRequest servletRequest
    ) {
        AuthResponse authResponse = authService.login(request);
        ApiResponse<AuthResponse> response = ApiResponse.success(
                "Login successfully.",
                authResponse,
                servletRequest.getRequestURI(),
                HttpStatus.OK.value()
        );

        return ResponseEntity.ok(response);
    }

    @Operation(
            summary = "Refresh access token",
            description = "Use a valid refresh token to issue a new JWT access token. No access token is required."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Access token refreshed successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request body"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Refresh token is invalid, expired, or revoked"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @PostMapping("/refresh")
    public ResponseEntity<ApiResponse<TokenResponse>> refresh(
            @Valid @RequestBody RefreshTokenRequest request,
            HttpServletRequest servletRequest
    ) {
        TokenResponse tokenResponse = authService.refresh(request);
        ApiResponse<TokenResponse> response = ApiResponse.success(
                "Access token refreshed successfully.",
                tokenResponse,
                servletRequest.getRequestURI(),
                HttpStatus.OK.value()
        );

        return ResponseEntity.ok(response);
    }

    @Operation(
            summary = "Logout",
            description = "Revoke a refresh token so it can no longer be used to obtain access tokens. No access token is required."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Logout successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request body"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Refresh token is invalid, expired, or revoked"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @PostMapping("/logout")
    public ResponseEntity<ApiResponse<Void>> logout(
            @Valid @RequestBody LogoutRequest request,
            HttpServletRequest servletRequest
    ) {
        authService.logout(request);
        ApiResponse<Void> response = ApiResponse.success(
                "Logout successfully.",
                null,
                servletRequest.getRequestURI(),
                HttpStatus.OK.value()
        );

        return ResponseEntity.ok(response);
    }

    @Operation(
            summary = "Get current authenticated user",
            description = "Requires Bearer JWT. Returns the current authenticated user profile and never exposes password or tokens."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Get current user successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing, invalid or expired access token"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Account is inactive"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "User not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping("/me")
    public ResponseEntity<ApiResponse<CurrentUserResponse>> getCurrentUser(
            Authentication authentication,
            HttpServletRequest servletRequest
    ) {
        CurrentUserResponse currentUser = authService.getCurrentUser(authentication);
        ApiResponse<CurrentUserResponse> response = ApiResponse.success(
                "Get current user successfully",
                currentUser,
                servletRequest.getRequestURI(),
                HttpStatus.OK.value()
        );

        return ResponseEntity.ok(response);
    }
}
