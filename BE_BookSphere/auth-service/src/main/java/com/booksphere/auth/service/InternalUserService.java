package com.booksphere.auth.service;

import com.booksphere.auth.dto.response.InternalUserResponse;

public interface InternalUserService {

    InternalUserResponse getInternalUser(Long userId);
}
