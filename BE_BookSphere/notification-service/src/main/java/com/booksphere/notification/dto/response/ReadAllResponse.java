package com.booksphere.notification.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Mark all notifications as read response")
public class ReadAllResponse {

    @Schema(description = "Number of notifications updated", example = "3")
    private int updatedCount;

    public ReadAllResponse(int updatedCount) {
        this.updatedCount = updatedCount;
    }

    public int getUpdatedCount() {
        return updatedCount;
    }

    public void setUpdatedCount(int updatedCount) {
        this.updatedCount = updatedCount;
    }
}
