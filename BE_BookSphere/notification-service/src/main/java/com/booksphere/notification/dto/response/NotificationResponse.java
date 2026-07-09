package com.booksphere.notification.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;

@Schema(description = "Notification response")
public class NotificationResponse {

    @Schema(description = "Notification ID", example = "9001")
    private Long id;
    @Schema(description = "Recipient user ID", example = "1")
    private Long userId;
    @Schema(description = "Notification title", example = "Borrow created")
    private String title;
    @Schema(description = "Notification content", example = "Your borrow request has been created successfully.")
    private String content;
    @Schema(description = "Notification type", example = "BORROW")
    private String type;
    @Schema(description = "Related entity ID such as borrowId or fineId", example = "1001")
    private Long referenceId;
    @Schema(description = "Idempotency event key", example = "BORROW_CREATED_1001")
    private String eventKey;
    @Schema(description = "Whether the notification is read", example = "false")
    private Boolean isRead;
    @Schema(description = "Creation timestamp", example = "2026-07-07T09:00:00")
    private LocalDateTime createdAt;
    @Schema(description = "Read timestamp", example = "2026-07-07T10:00:00")
    private LocalDateTime readAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Long getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(Long referenceId) {
        this.referenceId = referenceId;
    }

    public String getEventKey() {
        return eventKey;
    }

    public void setEventKey(String eventKey) {
        this.eventKey = eventKey;
    }

    public Boolean getIsRead() {
        return isRead;
    }

    public void setIsRead(Boolean isRead) {
        this.isRead = isRead;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getReadAt() {
        return readAt;
    }

    public void setReadAt(LocalDateTime readAt) {
        this.readAt = readAt;
    }
}
