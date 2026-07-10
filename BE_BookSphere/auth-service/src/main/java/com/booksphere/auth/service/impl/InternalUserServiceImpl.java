package com.booksphere.auth.service.impl;

import com.booksphere.auth.dto.response.InternalUserResponse;
import com.booksphere.auth.entity.User;
import com.booksphere.auth.exception.BusinessException;
import com.booksphere.auth.repository.UserRepository;
import com.booksphere.auth.service.InternalUserService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class InternalUserServiceImpl implements InternalUserService {

    private final UserRepository userRepository;

    public InternalUserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public InternalUserResponse getInternalUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(
                        "USER_NOT_FOUND",
                        "User not found.",
                        HttpStatus.NOT_FOUND
                ));

        return new InternalUserResponse(
                user.getId(),
                user.getFullName(),
                user.getUsername(),
                user.getEmail(),
                user.getActive()
        );
    }
}
