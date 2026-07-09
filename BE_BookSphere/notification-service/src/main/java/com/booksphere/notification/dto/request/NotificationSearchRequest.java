package com.booksphere.notification.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Notification search criteria")
public class NotificationSearchRequest {

    @Schema(description = "User ID filter", example = "1")
    private Long userId;
    @Schema(description = "Notification type filter", example = "BORROW")
    private String type;
    @Schema(description = "Read status filter", example = "false")
    private Boolean isRead;
    @Schema(description = "Zero-based page index", example = "0")
    private int page = 0;
    @Schema(description = "Page size", example = "10")
    private int size = 10;
    @Schema(description = "Sort field", example = "createdAt")
    private String sortBy = "createdAt";
    @Schema(description = "Sort direction", example = "desc")
    private String sortDir = "desc";

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Boolean getIsRead() {
        return isRead;
    }

    public void setIsRead(Boolean isRead) {
        this.isRead = isRead;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public String getSortBy() {
        return sortBy;
    }

    public void setSortBy(String sortBy) {
        this.sortBy = sortBy;
    }

    public String getSortDir() {
        return sortDir;
    }

    public void setSortDir(String sortDir) {
        this.sortDir = sortDir;
    }
}
