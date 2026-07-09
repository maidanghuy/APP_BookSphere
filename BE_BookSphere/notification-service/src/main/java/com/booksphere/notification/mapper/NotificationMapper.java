package com.booksphere.notification.mapper;

import com.booksphere.notification.dto.response.NotificationResponse;
import com.booksphere.notification.entity.Notification;

public final class NotificationMapper {

    private NotificationMapper() {
    }

    public static NotificationResponse toResponse(Notification notification) {
        NotificationResponse response = new NotificationResponse();
        response.setId(notification.getId());
        response.setUserId(notification.getUserId());
        response.setTitle(notification.getTitle());
        response.setContent(notification.getContent());
        response.setType(notification.getType());
        response.setReferenceId(notification.getReferenceId());
        response.setEventKey(notification.getEventKey());
        response.setIsRead(notification.getIsRead());
        response.setCreatedAt(notification.getCreatedAt());
        response.setReadAt(notification.getReadAt());
        return response;
    }
}
