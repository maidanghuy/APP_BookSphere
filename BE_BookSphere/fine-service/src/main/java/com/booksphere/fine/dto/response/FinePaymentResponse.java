package com.booksphere.fine.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Schema(description = "Fine payment response")
public class FinePaymentResponse {

    @Schema(description = "Payment ID", example = "7001")
    private Long id;
    @Schema(description = "Fine ID", example = "3001")
    private Long fineId;
    @Schema(description = "Paid amount", example = "15000")
    private BigDecimal amount;
    @Schema(description = "Payment method", example = "CASH")
    private String paymentMethod;
    @Schema(description = "Payment status", example = "PAID")
    private String paymentStatus;
    @Schema(description = "Payment timestamp", example = "2026-07-24T10:30:00")
    private LocalDateTime paidAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getFineId() {
        return fineId;
    }

    public void setFineId(Long fineId) {
        this.fineId = fineId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }
}
