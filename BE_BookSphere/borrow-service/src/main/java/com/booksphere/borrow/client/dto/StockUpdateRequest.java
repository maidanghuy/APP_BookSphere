package com.booksphere.borrow.client.dto;

public class StockUpdateRequest {

    private String sagaId;
    private Long bookId;
    private Integer quantity;

    public StockUpdateRequest() {
    }

    public StockUpdateRequest(String sagaId, Long bookId, Integer quantity) {
        this.sagaId = sagaId;
        this.bookId = bookId;
        this.quantity = quantity;
    }

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
