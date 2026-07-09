package com.booksphere.fine.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;

@Schema(description = "Borrow snapshot returned by Borrow Service")
public class BorrowInternalResponse {

    @Schema(description = "Borrow ID", example = "1001")
    private Long borrowId;
    @Schema(description = "User ID", example = "1")
    private Long userId;
    @Schema(description = "Due date", example = "2026-07-21T17:00:00")
    private LocalDateTime dueDate;
    @Schema(description = "Return date", example = "2026-07-24T10:30:00")
    private LocalDateTime returnDate;
    @Schema(description = "Borrow status", example = "OVERDUE")
    private String status;

    public Long getBorrowId() {
        return borrowId;
    }

    public void setBorrowId(Long borrowId) {
        this.borrowId = borrowId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public LocalDateTime getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDateTime dueDate) {
        this.dueDate = dueDate;
    }

    public LocalDateTime getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(LocalDateTime returnDate) {
        this.returnDate = returnDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
