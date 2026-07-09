package com.booksphere.book.controller;

import com.booksphere.book.dto.request.StockUpdateRequest;
import com.booksphere.book.dto.response.ApiResponse;
import com.booksphere.book.dto.response.InternalBookResponse;
import com.booksphere.book.dto.response.StockUpdateResponse;
import com.booksphere.book.service.BookService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/books")
@Tag(name = "Internal Book APIs", description = "Internal APIs for Saga stock update. Do not expose through API Gateway.")
public class InternalBookController {

    private final BookService bookService;

    public InternalBookController(BookService bookService) {
        this.bookService = bookService;
    }

    @Operation(
            summary = "Get internal book snapshot",
            description = "Internal service-to-service API. Do not expose this endpoint to external clients through API Gateway."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Book retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Book not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping("/{bookId}")
    public ResponseEntity<ApiResponse<InternalBookResponse>> getInternalBook(
            @PathVariable Long bookId,
            HttpServletRequest request
    ) {
        InternalBookResponse book = bookService.getInternalBook(bookId);
        return ResponseEntity.ok(ApiResponse.success(
                "Book retrieved successfully.",
                book,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Decrease stock for borrow Saga",
            description = "Internal service-to-service API. Do not expose this endpoint to external clients through API Gateway."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Stock decreased successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid stock update request"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Book not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Book inactive or insufficient available quantity"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @PutMapping("/{bookId}/decrease-stock")
    public ResponseEntity<ApiResponse<StockUpdateResponse>> decreaseStock(
            @PathVariable Long bookId,
            @Valid @RequestBody StockUpdateRequest body,
            HttpServletRequest request
    ) {
        StockUpdateResponse response = bookService.decreaseStock(bookId, body);
        return ResponseEntity.ok(ApiResponse.success(
                "Stock decreased successfully.",
                response,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Increase stock for Saga compensation or return",
            description = "Internal service-to-service API. Do not expose this endpoint to external clients through API Gateway."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Stock increased successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid stock update request"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Book not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Book inactive or stock update conflict"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @PutMapping("/{bookId}/increase-stock")
    public ResponseEntity<ApiResponse<StockUpdateResponse>> increaseStock(
            @PathVariable Long bookId,
            @Valid @RequestBody StockUpdateRequest body,
            HttpServletRequest request
    ) {
        StockUpdateResponse response = bookService.increaseStock(bookId, body);
        return ResponseEntity.ok(ApiResponse.success(
                "Stock increased successfully.",
                response,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }
}
