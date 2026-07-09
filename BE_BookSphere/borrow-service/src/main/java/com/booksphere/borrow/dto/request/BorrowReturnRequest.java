package com.booksphere.borrow.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;

@Schema(description = "Borrow return request")
public record BorrowReturnRequest(
        @Schema(description = "Return date. Defaults to current server time when omitted.", example = "2026-07-20T10:30:00")
        LocalDateTime returnDate
) {
}
