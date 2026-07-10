package com.booksphere.borrow.client.dto;

public class BookInternalResponse {

    private Long id;
    private String title;
    private String author;
    private String isbn;
    private Integer availableQuantity;
    private Boolean isActive;
    private Boolean categoryActive;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public Integer getAvailableQuantity() {
        return availableQuantity;
    }

    public void setAvailableQuantity(Integer availableQuantity) {
        this.availableQuantity = availableQuantity;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean active) {
        isActive = active;
    }

    public Boolean getCategoryActive() {
        return categoryActive;
    }

    public void setCategoryActive(Boolean categoryActive) {
        this.categoryActive = categoryActive;
    }
}
