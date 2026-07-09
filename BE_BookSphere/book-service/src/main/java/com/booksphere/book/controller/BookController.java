package com.booksphere.book.controller;

import com.booksphere.book.config.OpenApiConfig;
import com.booksphere.book.config.RoleChecker;
import com.booksphere.book.dto.request.BookCreateRequest;
import com.booksphere.book.dto.request.BookSearchRequest;
import com.booksphere.book.dto.request.BookUpdateRequest;
import com.booksphere.book.dto.response.ApiResponse;
import com.booksphere.book.dto.response.BookDetailResponse;
import com.booksphere.book.dto.response.BookResponse;
import com.booksphere.book.dto.response.PageResponse;
import com.booksphere.book.service.BookService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/books")
@Tag(name = "Books", description = "APIs for managing and searching books")
@SecurityRequirement(name = OpenApiConfig.SECURITY_SCHEME_NAME)
public class BookController {

    private final BookService bookService;

    public BookController(BookService bookService) {
        this.bookService = bookService;
    }

    @Operation(
            summary = "Search books",
            description = "Search active books by keyword and category with pagination. Requires JWT through API Gateway."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Books retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Insufficient role"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "429", description = "Too many requests"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<BookResponse>>> searchBooks(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id") String sortBy,
            @RequestParam(defaultValue = "asc") String sortDir,
            HttpServletRequest request
    ) {
        RoleChecker.requireReadRole(request);

        BookSearchRequest searchRequest = new BookSearchRequest();
        searchRequest.setKeyword(keyword);
        searchRequest.setCategoryId(categoryId);
        searchRequest.setPage(page);
        searchRequest.setSize(size);
        searchRequest.setSortBy(sortBy);
        searchRequest.setSortDir(sortDir);

        PageResponse<BookResponse> books = bookService.searchBooks(searchRequest);
        return ResponseEntity.ok(ApiResponse.success(
                "Books retrieved successfully.",
                books,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Get book detail",
            description = "Get an active book by ID. Requires JWT through API Gateway."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Book retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Insufficient role"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Book not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<BookDetailResponse>> getBookById(
            @PathVariable Long id,
            HttpServletRequest request
    ) {
        RoleChecker.requireReadRole(request);
        BookDetailResponse book = bookService.getActiveBookById(id);
        return ResponseEntity.ok(ApiResponse.success(
                "Book retrieved successfully.",
                book,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Create book",
            description = "Create a book in DBBook. Requires a librarian or administrator role from API Gateway headers."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Book created successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request body"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Insufficient role"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Category not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "ISBN already exists"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Business rule violation")
    })
    @PostMapping
    public ResponseEntity<ApiResponse<BookDetailResponse>> createBook(
            @Valid @RequestBody BookCreateRequest body,
            HttpServletRequest request
    ) {
        BookDetailResponse book = bookService.createBook(body, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(
                "Book created successfully.",
                book,
                request.getRequestURI(),
                HttpStatus.CREATED.value()
        ));
    }

    @Operation(
            summary = "Update book",
            description = "Update book metadata or stock fields. Requires a librarian or administrator role from API Gateway headers."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Book updated successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request body"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Insufficient role"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Book or category not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "ISBN already exists"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Business rule violation")
    })
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<BookDetailResponse>> updateBook(
            @PathVariable Long id,
            @Valid @RequestBody BookUpdateRequest body,
            HttpServletRequest request
    ) {
        BookDetailResponse book = bookService.updateBook(id, body, request);
        return ResponseEntity.ok(ApiResponse.success(
                "Book updated successfully.",
                book,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Delete book",
            description = "Soft delete a book. Requires a librarian or administrator role from API Gateway headers."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Book deleted successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Insufficient role"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Book not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Book cannot be deleted")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteBook(
            @PathVariable Long id,
            HttpServletRequest request
    ) {
        bookService.softDeleteBook(id, request);
        return ResponseEntity.ok(ApiResponse.success(
                "Book deleted successfully.",
                null,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }
}
