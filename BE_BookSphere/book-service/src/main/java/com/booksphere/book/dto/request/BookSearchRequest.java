package com.booksphere.book.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Book search criteria")
public class BookSearchRequest {

    @Schema(description = "Keyword used to search title, author, or ISBN", example = "clean")
    private String keyword;
    @Schema(description = "Category ID filter", example = "1")
    private Long categoryId;
    @Schema(description = "Zero-based page index", example = "0")
    private int page = 0;
    @Schema(description = "Page size", example = "10")
    private int size = 10;
    @Schema(description = "Sort field", example = "id")
    private String sortBy = "id";
    @Schema(description = "Sort direction", example = "asc")
    private String sortDir = "asc";

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public String getSortBy() {
        return sortBy;
    }

    public void setSortBy(String sortBy) {
        this.sortBy = sortBy;
    }

    public String getSortDir() {
        return sortDir;
    }

    public void setSortDir(String sortDir) {
        this.sortDir = sortDir;
    }
}
