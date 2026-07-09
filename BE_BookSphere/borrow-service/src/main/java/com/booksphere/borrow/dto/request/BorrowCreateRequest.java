package com.booksphere.borrow.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "Borrow create request")
public record BorrowCreateRequest(
        @NotNull(message = "Due date is required.")
        @Future(message = "Due date must be in the future.")
        @Schema(description = "Due date for returning the books", example = "2026-07-21T17:00:00")
        LocalDateTime dueDate,

        @Valid
        @NotEmpty(message = "Borrow items must not be empty.")
        @Schema(description = "Books and quantities to borrow")
        List<BorrowItemRequest> items
) {
}
