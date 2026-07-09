package com.booksphere.fine.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "Paged response")
public class PageResponse<T> {

    @Schema(description = "Page content")
    private List<T> content;
    @Schema(description = "Zero-based page index", example = "0")
    private int page;
    @Schema(description = "Page size", example = "10")
    private int size;
    @Schema(description = "Total number of elements", example = "42")
    private long totalElements;
    @Schema(description = "Total number of pages", example = "5")
    private int totalPages;

    public List<T> getContent() {
        return content;
    }

    public void setContent(List<T> content) {
        this.content = content;
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

    public long getTotalElements() {
        return totalElements;
    }

    public void setTotalElements(long totalElements) {
        this.totalElements = totalElements;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }
}
