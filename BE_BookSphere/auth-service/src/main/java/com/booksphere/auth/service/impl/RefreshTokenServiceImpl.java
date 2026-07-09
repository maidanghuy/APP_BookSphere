package com.booksphere.auth.service.impl;

import com.booksphere.auth.entity.RefreshToken;
import com.booksphere.auth.entity.User;
import com.booksphere.auth.exception.BusinessException;
import com.booksphere.auth.repository.RefreshTokenRepository;
import com.booksphere.auth.security.JwtProperties;
import com.booksphere.auth.service.RefreshTokenService;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RefreshTokenServiceImpl implements RefreshTokenService {

    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private final RefreshTokenRepository refreshTokenRepository;
    private final JwtProperties jwtProperties;

    public RefreshTokenServiceImpl(
            RefreshTokenRepository refreshTokenRepository,
            JwtProperties jwtProperties
    ) {
        this.refreshTokenRepository = refreshTokenRepository;
        this.jwtProperties = jwtProperties;
    }

    @Override
    @Transactional
    public RefreshToken createRefreshToken(User user) {
        RefreshToken refreshToken = new RefreshToken(
                user,
                generateSecureToken(),
                LocalDateTime.now().plusDays(jwtProperties.getRefreshTokenExpirationDays()),
                false
        );

        return refreshTokenRepository.save(refreshToken);
    }

    @Override
    @Transactional
    public RefreshToken validateRefreshToken(String token) {
        RefreshToken refreshToken = refreshTokenRepository.findByToken(token)
                .orElseThrow(() -> new BusinessException(
                        "AUTH_REFRESH_TOKEN_INVALID",
                        "Refresh token is invalid.",
                        HttpStatus.UNAUTHORIZED
                ));

        if (Boolean.TRUE.equals(refreshToken.getRevoked())) {
            throw new BusinessException(
                    "AUTH_REFRESH_TOKEN_INVALID",
                    "Refresh token is invalid.",
                    HttpStatus.UNAUTHORIZED
            );
        }

        if (refreshToken.getExpiryDate().isBefore(LocalDateTime.now())) {
            refreshToken.setRevoked(true);
            refreshTokenRepository.save(refreshToken);
            throw new BusinessException(
                    "AUTH_TOKEN_EXPIRED",
                    "Refresh token is expired.",
                    HttpStatus.UNAUTHORIZED
            );
        }

        if (!Boolean.TRUE.equals(refreshToken.getUser().getActive())) {
            throw new BusinessException(
                    "AUTH_ACCOUNT_INACTIVE",
                    "Account is inactive.",
                    HttpStatus.FORBIDDEN
            );
        }

        return refreshToken;
    }

    @Override
    @Transactional
    public void revokeRefreshToken(String token) {
        refreshTokenRepository.findByToken(token).ifPresent(refreshToken -> {
            refreshToken.setRevoked(true);
            refreshTokenRepository.save(refreshToken);
        });
    }

    private String generateSecureToken() {
        byte[] bytes = new byte[48];
        SECURE_RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
