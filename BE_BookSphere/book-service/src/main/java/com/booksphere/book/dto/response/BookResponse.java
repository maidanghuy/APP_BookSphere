package com.booksphere.book.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Book summary response")
public class BookResponse {

    @Schema(description = "Book ID", example = "1")
    private Long id;
    @Schema(description = "Book title", example = "Clean Code")
    private String title;
    @Schema(description = "Book author", example = "Robert C. Martin")
    private String author;
    @Schema(description = "ISBN code", example = "9780132350884")
    private String isbn;
    @Schema(description = "Category ID", example = "1")
    private Long categoryId;
    @Schema(description = "Category name", example = "Software Engineering")
    private String categoryName;
    @Schema(description = "Total quantity in library inventory", example = "10")
    private Integer totalQuantity;
    @Schema(description = "Available quantity", example = "8")
    private Integer availableQuantity;
    @Schema(description = "Whether the book is active", example = "true")
    private Boolean isActive;

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

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public Integer getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(Integer totalQuantity) {
        this.totalQuantity = totalQuantity;
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

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
}
