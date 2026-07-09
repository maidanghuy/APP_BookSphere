package com.booksphere.book.controller;

import com.booksphere.book.config.OpenApiConfig;
import com.booksphere.book.config.RoleChecker;
import com.booksphere.book.dto.request.CategoryRequest;
import com.booksphere.book.dto.response.ApiResponse;
import com.booksphere.book.dto.response.CategoryResponse;
import com.booksphere.book.service.CategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/categories")
@Tag(name = "Categories", description = "APIs for managing book categories")
@SecurityRequirement(name = OpenApiConfig.SECURITY_SCHEME_NAME)
public class CategoryController {

    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @Operation(
            summary = "List categories",
            description = "Get all active book categories. Requires JWT through API Gateway."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Categories retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Insufficient role"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping
    public ResponseEntity<ApiResponse<List<CategoryResponse>>> getAllCategories(HttpServletRequest request) {
        RoleChecker.requireReadRole(request);
        List<CategoryResponse> categories = categoryService.getAllActiveCategories();
        return ResponseEntity.ok(ApiResponse.success(
                "Categories retrieved successfully.",
                categories,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Get category detail",
            description = "Get an active category by ID. Requires JWT through API Gateway."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Category retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Insufficient role"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Category not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoryResponse>> getCategoryById(
            @PathVariable Long id,
            HttpServletRequest request
    ) {
        RoleChecker.requireReadRole(request);
        CategoryResponse category = categoryService.getActiveCategoryById(id);
        return ResponseEntity.ok(ApiResponse.success(
                "Category retrieved successfully.",
                category,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Create category",
            description = "Create a book category. Requires a librarian or administrator role from API Gateway headers."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Category created successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request body"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Insufficient role"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Category name already exists")
    })
    @PostMapping
    public ResponseEntity<ApiResponse<CategoryResponse>> createCategory(
            @Valid @RequestBody CategoryRequest body,
            HttpServletRequest request
    ) {
        CategoryResponse category = categoryService.createCategory(body, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(
                "Category created successfully.",
                category,
                request.getRequestURI(),
                HttpStatus.CREATED.value()
        ));
    }

    @Operation(
            summary = "Update category",
            description = "Update a book category. Requires a librarian or administrator role from API Gateway headers."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Category updated successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request body"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Insufficient role"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Category not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Category name already exists")
    })
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<CategoryResponse>> updateCategory(
            @PathVariable Long id,
            @Valid @RequestBody CategoryRequest body,
            HttpServletRequest request
    ) {
        CategoryResponse category = categoryService.updateCategory(id, body, request);
        return ResponseEntity.ok(ApiResponse.success(
                "Category updated successfully.",
                category,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Delete category",
            description = "Soft delete a category when no active books still use it."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Category deleted successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Insufficient role"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Category not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Category still has active books")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteCategory(
            @PathVariable Long id,
            HttpServletRequest request
    ) {
        categoryService.softDeleteCategory(id, request);
        return ResponseEntity.ok(ApiResponse.success(
                "Category deleted successfully.",
                null,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }
}
