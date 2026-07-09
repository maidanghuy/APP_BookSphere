package com.booksphere.book.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Schema(description = "Book create request")
public class BookCreateRequest {

    @NotBlank(message = "Title is required.")
    @Size(max = 255, message = "Title must not exceed 255 characters.")
    @Schema(description = "Book title", example = "Clean Code")
    private String title;

    @NotBlank(message = "Author is required.")
    @Size(max = 150, message = "Author must not exceed 150 characters.")
    @Schema(description = "Book author", example = "Robert C. Martin")
    private String author;

    @NotBlank(message = "ISBN is required.")
    @Size(max = 30, message = "ISBN must not exceed 30 characters.")
    @Schema(description = "ISBN code", example = "9780132350884")
    private String isbn;

    @Size(max = 150, message = "Publisher must not exceed 150 characters.")
    @Schema(description = "Publisher name", example = "Prentice Hall")
    private String publisher;

    @Schema(description = "Published year", example = "2008")
    private Integer publishedYear;

    @NotNull(message = "Category ID is required.")
    @Schema(description = "Category ID", example = "1")
    private Long categoryId;

    @NotNull(message = "Total quantity is required.")
    @Min(value = 0, message = "Total quantity must be greater than or equal to 0.")
    @Schema(description = "Total quantity in library inventory", example = "10")
    private Integer totalQuantity;

    @Min(value = 0, message = "Available quantity must be greater than or equal to 0.")
    @Schema(description = "Available quantity. Defaults to total quantity when omitted.", example = "10")
    private Integer availableQuantity;

    @Schema(description = "Book description", example = "A handbook of agile software craftsmanship.")
    private String description;

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
}
