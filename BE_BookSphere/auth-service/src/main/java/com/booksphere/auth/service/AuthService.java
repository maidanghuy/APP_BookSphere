package com.booksphere.auth.service;

import com.booksphere.auth.dto.request.LoginRequest;
import com.booksphere.auth.dto.request.LogoutRequest;
import com.booksphere.auth.dto.request.RefreshTokenRequest;
import com.booksphere.auth.dto.request.RegisterRequest;
import com.booksphere.auth.dto.response.AuthResponse;
import com.booksphere.auth.dto.response.TokenResponse;

public interface AuthService {

    AuthResponse register(RegisterRequest request);

    AuthResponse login(LoginRequest request);

    TokenResponse refresh(RefreshTokenRequest request);

    void logout(LogoutRequest request);
}
