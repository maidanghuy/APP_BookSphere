package com.booksphere.fine.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Schema(description = "Internal fine create request")
public class FineCreateRequest {

    @NotNull
    @Schema(description = "Borrow ID that generated the fine", example = "1001")
    private Long borrowId;

    @NotNull
    @Schema(description = "User ID responsible for the fine", example = "1")
    private Long userId;

    @Schema(description = "Original due date", example = "2026-07-21T17:00:00")
    private LocalDateTime dueDate;

    @Schema(description = "Actual return date", example = "2026-07-24T10:30:00")
    private LocalDateTime returnDate;

    @Min(0)
    @Schema(description = "Number of overdue days", example = "3")
    private Integer daysOverdue;

    @NotBlank
    @Schema(description = "Source flow that created the fine", example = "LATE_RETURN")
    private String createdFrom;

    @Schema(description = "Fine reason", example = "Returned 3 days after due date.")
    private String reason;

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

    public Integer getDaysOverdue() {
        return daysOverdue;
    }

    public void setDaysOverdue(Integer daysOverdue) {
        this.daysOverdue = daysOverdue;
    }

    public String getCreatedFrom() {
        return createdFrom;
    }

    public void setCreatedFrom(String createdFrom) {
        this.createdFrom = createdFrom;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
}
