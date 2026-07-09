package com.booksphere.book.service;

import com.booksphere.book.dto.request.CategoryRequest;
import com.booksphere.book.dto.response.CategoryResponse;
import jakarta.servlet.http.HttpServletRequest;
import java.util.List;

public interface CategoryService {

    List<CategoryResponse> getAllActiveCategories();

    CategoryResponse getActiveCategoryById(Long id);

    CategoryResponse createCategory(CategoryRequest request, HttpServletRequest httpRequest);

    CategoryResponse updateCategory(Long id, CategoryRequest request, HttpServletRequest httpRequest);

    void softDeleteCategory(Long id, HttpServletRequest httpRequest);
}
