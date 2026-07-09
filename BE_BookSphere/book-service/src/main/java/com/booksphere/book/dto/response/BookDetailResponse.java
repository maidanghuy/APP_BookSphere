package com.booksphere.book.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;

@Schema(description = "Book detail response")
public class BookDetailResponse {

    @Schema(description = "Book ID", example = "1")
    private Long id;
    @Schema(description = "Book title", example = "Clean Code")
    private String title;
    @Schema(description = "Book author", example = "Robert C. Martin")
    private String author;
    @Schema(description = "ISBN code", example = "9780132350884")
    private String isbn;
    @Schema(description = "Publisher name", example = "Prentice Hall")
    private String publisher;
    @Schema(description = "Published year", example = "2008")
    private Integer publishedYear;
    @Schema(description = "Category ID", example = "1")
    private Long categoryId;
    @Schema(description = "Category name", example = "Software Engineering")
    private String categoryName;
    @Schema(description = "Total quantity in library inventory", example = "10")
    private Integer totalQuantity;
    @Schema(description = "Available quantity", example = "8")
    private Integer availableQuantity;
    @Schema(description = "Book description", example = "A handbook of agile software craftsmanship.")
    private String description;
    @Schema(description = "Whether the book is active", example = "true")
    private Boolean isActive;
    @Schema(description = "Creation timestamp", example = "2026-07-04T15:30:00")
    private LocalDateTime createdAt;
    @Schema(description = "Last update timestamp", example = "2026-07-04T16:00:00")
    private LocalDateTime updatedAt;

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

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public Integer getPublishedYear() {
        return publishedYear;
    }

    public void setPublishedYear(Integer publishedYear) {
        this.publishedYear = publishedYear;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
