package com.booksphere.borrow.client;

import com.booksphere.borrow.client.dto.ClientApiResponse;
import com.booksphere.borrow.client.dto.UserInternalResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "auth-service")
public interface AuthServiceClient {

    @GetMapping("/internal/users/{userId}")
    ClientApiResponse<UserInternalResponse> getInternalUser(@PathVariable Long userId);
}
