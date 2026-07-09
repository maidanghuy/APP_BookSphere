package com.booksphere.auth.service;

import com.booksphere.auth.entity.RefreshToken;
import com.booksphere.auth.entity.User;

public interface RefreshTokenService {

    RefreshToken createRefreshToken(User user);

    RefreshToken validateRefreshToken(String token);

    void revokeRefreshToken(String token);
}
