package com.booksphere.book.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Schema(description = "Category create or update request")
public class CategoryRequest {

    @NotBlank(message = "Category name is required.")
    @Size(max = 100, message = "Category name must not exceed 100 characters.")
    @Schema(description = "Category name", example = "Software Engineering")
    private String name;

    @Schema(description = "Category description", example = "Books about software engineering practices.")
    private String description;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
