package com.booksphere.fine.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import java.math.BigDecimal;

@Schema(description = "Fine payment request")
public class FinePaymentRequest {

    @NotBlank
    @Schema(description = "Payment method", example = "CASH")
    private String paymentMethod;

    @Schema(description = "Paid amount. Defaults to the fine amount when omitted.", example = "15000")
    private BigDecimal amount;

    @Schema(description = "Payment status", example = "PAID")
    private String paymentStatus;

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
}
