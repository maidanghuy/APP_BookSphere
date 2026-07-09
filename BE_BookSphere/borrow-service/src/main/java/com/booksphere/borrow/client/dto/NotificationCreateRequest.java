package com.booksphere.borrow.client.dto;

public record NotificationCreateRequest(
        Long userId,
        String title,
        String content,
        String type,
        Long referenceId,
        String eventKey
) {
}
