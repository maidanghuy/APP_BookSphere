package com.booksphere.notification.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Schema(description = "Internal notification create request")
public class NotificationCreateRequest {

    @NotNull
    @Schema(description = "Recipient user ID", example = "1")
    private Long userId;

    @NotBlank
    @Size(max = 255)
    @Schema(description = "Notification title", example = "Borrow created")
    private String title;

    @Schema(description = "Notification content", example = "Your borrow request has been created successfully.")
    private String content;

    @NotBlank
    @Schema(description = "Notification type", example = "BORROW")
    private String type;

    @Schema(description = "Related entity ID such as borrowId or fineId", example = "1001")
    private Long referenceId;

    @NotBlank
    @Size(max = 150)
    @Schema(description = "Idempotency event key", example = "BORROW_CREATED_1001")
    private String eventKey;

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
}
