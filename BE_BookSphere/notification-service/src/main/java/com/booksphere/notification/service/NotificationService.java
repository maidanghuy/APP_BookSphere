package com.booksphere.notification.service;

import com.booksphere.notification.config.UserContext;
import com.booksphere.notification.dto.request.NotificationCreateRequest;
import com.booksphere.notification.dto.request.NotificationSearchRequest;
import com.booksphere.notification.dto.response.NotificationCreateResult;
import com.booksphere.notification.dto.response.NotificationResponse;
import com.booksphere.notification.dto.response.PageResponse;
import com.booksphere.notification.dto.response.ReadAllResponse;

public interface NotificationService {

    NotificationCreateResult createNotificationInternal(NotificationCreateRequest request);

    PageResponse<NotificationResponse> searchMyNotifications(NotificationSearchRequest request, UserContext userContext);

    PageResponse<NotificationResponse> searchNotifications(NotificationSearchRequest request, UserContext userContext);

    NotificationResponse getNotificationById(Long notificationId, UserContext userContext);

    NotificationResponse markAsRead(Long notificationId, UserContext userContext);

    ReadAllResponse markAllAsRead(UserContext userContext);
}
