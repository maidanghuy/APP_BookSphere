package com.booksphere.borrow.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

@Schema(description = "Paged response")
public record PageResponse<T>(
        @Schema(description = "Page content")
        List<T> content,
        @Schema(description = "Zero-based page index", example = "0")
        int page,
        @Schema(description = "Page size", example = "10")
        int size,
        @Schema(description = "Total number of elements", example = "42")
        long totalElements,
        @Schema(description = "Total number of pages", example = "5")
        int totalPages,
        @Schema(description = "Whether this is the last page", example = "false")
        boolean last
) {
}
