package com.booksphere.book.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

@Schema(description = "Internal stock update request")
public class StockUpdateRequest {

    @NotBlank(message = "Saga ID is required.")
    @Schema(description = "Saga transaction ID for idempotency", example = "BORROW_1001_DECREASE")
    private String sagaId;

    @Schema(description = "Book ID. The path variable is authoritative.", example = "1")
    private Long bookId;

    @NotNull(message = "Quantity is required.")
    @Min(value = 1, message = "Quantity must be greater than 0.")
    @Schema(description = "Quantity to increase or decrease", example = "1")
    private Integer quantity;

    public String getSagaId() {
        return sagaId;
    }

    public void setSagaId(String sagaId) {
        this.sagaId = sagaId;
    }

    public Long getBookId() {
        return bookId;
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}
