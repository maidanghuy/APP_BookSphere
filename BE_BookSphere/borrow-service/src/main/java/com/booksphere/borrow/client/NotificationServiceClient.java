package com.booksphere.borrow.client;

import com.booksphere.borrow.client.dto.ClientApiResponse;
import com.booksphere.borrow.client.dto.NotificationCreateRequest;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "notification-service")
public interface NotificationServiceClient {

    @PostMapping("/internal/notifications")
    ClientApiResponse<Object> createNotification(@RequestBody NotificationCreateRequest request);
}
