package com.booksphere.fine.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Schema(description = "Fine response")
public class FineResponse {

    @Schema(description = "Fine ID", example = "3001")
    private Long id;
    @Schema(description = "User ID", example = "1")
    private Long userId;
    @Schema(description = "Borrow ID", example = "1001")
    private Long borrowId;
    @Schema(description = "Fine amount", example = "15000")
    private BigDecimal amount;
    @Schema(description = "Source flow that created the fine", example = "RETURN_LATE")
    private String createdFrom;
    @Schema(description = "Fine reason", example = "Returned 3 days after due date.")
    private String reason;
    @Schema(description = "Fine status", example = "UNPAID")
    private String status;
    @Schema(description = "Creation timestamp", example = "2026-07-24T10:30:00")
    private LocalDateTime createdAt;
    @Schema(description = "Payment timestamp", example = "2026-07-24T11:00:00")
    private LocalDateTime paidAt;

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

    public Long getBorrowId() {
        return borrowId;
    }

    public void setBorrowId(Long borrowId) {
        this.borrowId = borrowId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }
}
