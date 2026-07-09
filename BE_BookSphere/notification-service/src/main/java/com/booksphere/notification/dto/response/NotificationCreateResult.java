package com.booksphere.notification.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Internal notification create result")
public class NotificationCreateResult {

    @Schema(description = "Notification response")
    private NotificationResponse notification;
    @Schema(description = "Whether a new notification was created", example = "true")
    private boolean created;

    public NotificationCreateResult(NotificationResponse notification, boolean created) {
        this.notification = notification;
        this.created = created;
    }

    public NotificationResponse getNotification() {
        return notification;
    }

    public void setNotification(NotificationResponse notification) {
        this.notification = notification;
    }

    public boolean isCreated() {
        return created;
    }

    public void setCreated(boolean created) {
        this.created = created;
    }
}
