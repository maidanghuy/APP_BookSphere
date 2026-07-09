package com.booksphere.book.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;

@Schema(description = "Category response")
public class CategoryResponse {

    @Schema(description = "Category ID", example = "1")
    private Long id;
    @Schema(description = "Category name", example = "Software Engineering")
    private String name;
    @Schema(description = "Category description", example = "Books about software engineering practices.")
    private String description;
    @Schema(description = "Whether the category is active", example = "true")
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
