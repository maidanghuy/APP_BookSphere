package com.booksphere.book.dto.response;

import com.booksphere.book.entity.enums.StockAction;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Internal stock update response")
public class StockUpdateResponse {

    @Schema(description = "Book ID", example = "1")
    private Long bookId;
    @Schema(description = "Saga transaction ID", example = "BORROW_1001_DECREASE")
    private String sagaId;
    @Schema(description = "Stock action", example = "DECREASE")
    private StockAction action;
    @Schema(description = "Quantity changed", example = "1")
    private Integer quantity;
    @Schema(description = "Available quantity after the update", example = "7")
    private Integer availableQuantity;
    @Schema(description = "Whether this response came from an idempotent duplicate request", example = "false")
    private boolean idempotent;

    public Long getBookId() {
        return bookId;
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    public String getSagaId() {
        return sagaId;
    }

    public void setSagaId(String sagaId) {
        this.sagaId = sagaId;
    }

    public StockAction getAction() {
        return action;
    }

    public void setAction(StockAction action) {
        this.action = action;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Integer getAvailableQuantity() {
        return availableQuantity;
    }

    public void setAvailableQuantity(Integer availableQuantity) {
        this.availableQuantity = availableQuantity;
    }

    public boolean isIdempotent() {
        return idempotent;
    }

    public void setIdempotent(boolean idempotent) {
        this.idempotent = idempotent;
    }
}
