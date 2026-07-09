package com.booksphere.fine.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Fine search criteria")
public class FineSearchRequest {

    @Schema(description = "User ID filter", example = "1")
    private Long userId;
    @Schema(description = "Borrow ID filter", example = "1001")
    private Long borrowId;
    @Schema(description = "Fine status filter", example = "UNPAID")
    private String status;
    @Schema(description = "Zero-based page index", example = "0")
    private int page = 0;
    @Schema(description = "Page size", example = "10")
    private int size = 10;
    @Schema(description = "Sort field", example = "createdAt")
    private String sortBy = "createdAt";
    @Schema(description = "Sort direction", example = "desc")
    private String sortDir = "desc";

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getBorrowId() {
        return borrowId;
    }

    public void setBorrowId(Long borrowId) {
        this.borrowId = borrowId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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
