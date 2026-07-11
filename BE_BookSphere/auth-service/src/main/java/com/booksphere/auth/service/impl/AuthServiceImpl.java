package com.booksphere.auth.service.impl;

import com.booksphere.auth.dto.request.LoginRequest;
import com.booksphere.auth.dto.request.LogoutRequest;
import com.booksphere.auth.dto.request.RefreshTokenRequest;
import com.booksphere.auth.dto.request.RegisterRequest;
import com.booksphere.auth.dto.response.AuthResponse;
import com.booksphere.auth.dto.response.CurrentUserResponse;
import com.booksphere.auth.dto.response.TokenResponse;
import com.booksphere.auth.dto.response.UserResponse;
import com.booksphere.auth.entity.RefreshToken;
import com.booksphere.auth.entity.Role;
import com.booksphere.auth.entity.User;
import com.booksphere.auth.entity.UserRole;
import com.booksphere.auth.exception.BusinessException;
import com.booksphere.auth.repository.RoleRepository;
import com.booksphere.auth.repository.UserRepository;
import com.booksphere.auth.repository.UserRoleRepository;
import com.booksphere.auth.security.JwtService;
import com.booksphere.auth.service.AuthService;
import com.booksphere.auth.service.RefreshTokenService;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthServiceImpl implements AuthService {

    private static final String TOKEN_TYPE = "Bearer";
    private static final String MEMBER_ROLE = "MEMBER";

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final UserRoleRepository userRoleRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final RefreshTokenService refreshTokenService;

    public AuthServiceImpl(
            UserRepository userRepository,
            RoleRepository roleRepository,
            UserRoleRepository userRoleRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService,
            RefreshTokenService refreshTokenService
    ) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.userRoleRepository = userRoleRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.refreshTokenService = refreshTokenService;
    }

    @Override
    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByUsername(request.username())) {
            throw new BusinessException(
                    "AUTH_USERNAME_DUPLICATED",
                    "Username already exists.",
                    HttpStatus.CONFLICT
            );
        }

        if (userRepository.existsByEmail(request.email())) {
            throw new BusinessException(
                    "AUTH_EMAIL_DUPLICATED",
                    "Email already exists.",
                    HttpStatus.CONFLICT
            );
        }

        Role memberRole = roleRepository.findByName(MEMBER_ROLE)
                .orElseThrow(() -> new BusinessException(
                        "INTERNAL_SERVER_ERROR",
                        "Default role MEMBER is not available.",
                        HttpStatus.INTERNAL_SERVER_ERROR
                ));

        User user = new User(
                request.fullName(),
                request.username(),
                request.email(),
                passwordEncoder.encode(request.password()),
                request.phone(),
                true
        );
        User savedUser = userRepository.save(user);
        userRoleRepository.save(new UserRole(savedUser, memberRole));

        List<String> roles = List.of(memberRole.getName());
        RefreshToken refreshToken = refreshTokenService.createRefreshToken(savedUser);

        return buildAuthResponse(savedUser, roles, refreshToken.getToken());
    }

    @Override
    @Transactional
    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByUsername(request.username())
                .orElseThrow(this::invalidCredentials);

        if (!Boolean.TRUE.equals(user.getActive())) {
            throw new BusinessException(
                    "AUTH_ACCOUNT_INACTIVE",
                    "Account is inactive.",
                    HttpStatus.FORBIDDEN
            );
        }

        if (!passwordEncoder.matches(request.password(), user.getPassword())) {
            throw invalidCredentials();
        }

        List<String> roles = getRoleNames(user);
        RefreshToken refreshToken = refreshTokenService.createRefreshToken(user);

        return buildAuthResponse(user, roles, refreshToken.getToken());
    }

    @Override
    @Transactional
    public TokenResponse refresh(RefreshTokenRequest request) {
        RefreshToken refreshToken = refreshTokenService.validateRefreshToken(request.refreshToken());
        User user = refreshToken.getUser();
        List<String> roles = getRoleNames(user);
        String accessToken = jwtService.generateAccessToken(user, roles);

        return new TokenResponse(accessToken, TOKEN_TYPE, jwtService.getAccessTokenExpiresInSeconds());
    }

    @Override
    public void logout(LogoutRequest request) {
        refreshTokenService.revokeRefreshToken(request.refreshToken());
    }

    @Override
    @Transactional(readOnly = true)
    public CurrentUserResponse getCurrentUser(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new BusinessException(
                    "AUTH_UNAUTHORIZED",
                    "User is not authenticated.",
                    HttpStatus.UNAUTHORIZED
            );
        }

        String username = authentication.getName();
        if (username == null || username.isBlank()) {
            throw new BusinessException(
                    "AUTH_UNAUTHORIZED",
                    "User is not authenticated.",
                    HttpStatus.UNAUTHORIZED
            );
        }

        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new BusinessException(
                        "USER_NOT_FOUND",
                        "User not found.",
                        HttpStatus.NOT_FOUND
                ));

        if (!Boolean.TRUE.equals(user.getActive())) {
            throw new BusinessException(
                    "AUTH_ACCOUNT_INACTIVE",
                    "Account is inactive.",
                    HttpStatus.FORBIDDEN
            );
        }

        List<String> roles = getRoleNames(user);

        return new CurrentUserResponse(
                user.getId(),
                user.getUsername(),
                user.getFullName(),
                user.getEmail(),
                user.getPhone(),
                roles.isEmpty() ? null : roles.get(0),
                roles,
                user.getActive()
        );
    }

    private AuthResponse buildAuthResponse(User user, List<String> roles, String refreshToken) {
        String accessToken = jwtService.generateAccessToken(user, roles);
        UserResponse userResponse = new UserResponse(
                user.getId(),
                user.getFullName(),
                user.getUsername(),
                user.getEmail(),
                user.getPhone(),
                roles,
                user.getActive()
        );

        return new AuthResponse(
                userResponse,
                accessToken,
                refreshToken,
                TOKEN_TYPE,
                jwtService.getAccessTokenExpiresInSeconds()
        );
    }

    private List<String> getRoleNames(User user) {
        return userRoleRepository.findByUser_Id(user.getId())
                .stream()
                .map(userRole -> userRole.getRole().getName())
                .toList();
    }

    private BusinessException invalidCredentials() {
        return new BusinessException(
                "AUTH_INVALID_CREDENTIALS",
                "Invalid username or password.",
                HttpStatus.UNAUTHORIZED
        );
    }
}
