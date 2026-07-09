package com.booksphere.book.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Internal book snapshot response")
public class InternalBookResponse {

    @Schema(description = "Book ID", example = "1")
    private Long id;
    @Schema(description = "Book title", example = "Clean Code")
    private String title;
    @Schema(description = "ISBN code", example = "9780132350884")
    private String isbn;
    @Schema(description = "Available quantity", example = "8")
    private Integer availableQuantity;
    @Schema(description = "Whether the book is active", example = "true")
    private Boolean isActive;
    @Schema(description = "Whether the book category is active", example = "true")
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

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Boolean getCategoryActive() {
        return categoryActive;
    }

    public void setCategoryActive(Boolean categoryActive) {
        this.categoryActive = categoryActive;
    }
}
