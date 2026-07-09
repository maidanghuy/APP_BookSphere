package com.booksphere.book.service.impl;

import com.booksphere.book.config.CacheConfig;
import com.booksphere.book.config.RoleChecker;
import com.booksphere.book.dto.request.CategoryRequest;
import com.booksphere.book.cache.CategoryListCacheValue;
import com.booksphere.book.dto.response.CategoryResponse;
import com.booksphere.book.entity.Category;
import com.booksphere.book.exception.BusinessException;
import com.booksphere.book.mapper.CategoryMapper;
import com.booksphere.book.repository.BookRepository;
import com.booksphere.book.repository.CategoryRepository;
import com.booksphere.book.service.CategoryService;
import jakarta.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.HttpStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository categoryRepository;
    private final BookRepository bookRepository;

    @Lazy
    @Autowired
    private CategoryServiceImpl self;

    public CategoryServiceImpl(CategoryRepository categoryRepository, BookRepository bookRepository) {
        this.categoryRepository = categoryRepository;
        this.bookRepository = bookRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<CategoryResponse> getAllActiveCategories() {
        return self.getAllActiveCategoriesCached().getCategories();
    }

    @Cacheable(
            cacheNames = CacheConfig.CATEGORIES_ACTIVE_CACHE,
            key = "'all-active'",
            unless = "#result == null"
    )
    public CategoryListCacheValue getAllActiveCategoriesCached() {
        List<CategoryResponse> categories = categoryRepository.findAllByIsActiveTrue()
                .stream()
                .map(CategoryMapper::toResponse)
                .toList();

        CategoryListCacheValue cacheValue = new CategoryListCacheValue();
        cacheValue.setCategories(new ArrayList<>(categories));
        return cacheValue;
    }

    @Override
    @Transactional(readOnly = true)
    public CategoryResponse getActiveCategoryById(Long id) {
        Category category = categoryRepository.findByIdAndIsActiveTrue(id)
                .orElseThrow(() -> new BusinessException(
                        "CATEGORY_NOT_FOUND",
                        "Category not found.",
                        HttpStatus.NOT_FOUND
                ));
        return CategoryMapper.toResponse(category);
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(cacheNames = CacheConfig.CATEGORIES_ACTIVE_CACHE, allEntries = true),
            @CacheEvict(cacheNames = CacheConfig.BOOKS_ACTIVE_CACHE, allEntries = true),
            @CacheEvict(cacheNames = CacheConfig.BOOK_DETAIL_CACHE, allEntries = true)
    })
    public CategoryResponse createCategory(CategoryRequest request, HttpServletRequest httpRequest) {
        RoleChecker.requireWriteRole(httpRequest);

        if (categoryRepository.existsByNameIgnoreCase(request.getName())) {
            throw new BusinessException(
                    "CATEGORY_NAME_DUPLICATED",
                    "Category name already exists.",
                    HttpStatus.CONFLICT
            );
        }

        Category category = new Category();
        category.setName(request.getName().trim());
        category.setDescription(request.getDescription());
        category.setIsActive(true);

        return CategoryMapper.toResponse(categoryRepository.save(category));
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(cacheNames = CacheConfig.CATEGORIES_ACTIVE_CACHE, allEntries = true),
            @CacheEvict(cacheNames = CacheConfig.BOOKS_ACTIVE_CACHE, allEntries = true),
            @CacheEvict(cacheNames = CacheConfig.BOOK_DETAIL_CACHE, allEntries = true)
    })
    public CategoryResponse updateCategory(Long id, CategoryRequest request, HttpServletRequest httpRequest) {
        RoleChecker.requireWriteRole(httpRequest);

        Category category = categoryRepository.findByIdAndIsActiveTrue(id)
                .orElseThrow(() -> new BusinessException(
                        "CATEGORY_NOT_FOUND",
                        "Category not found.",
                        HttpStatus.NOT_FOUND
                ));

        if (categoryRepository.existsByNameIgnoreCaseAndIdNot(request.getName(), id)) {
            throw new BusinessException(
                    "CATEGORY_NAME_DUPLICATED",
                    "Category name already exists.",
                    HttpStatus.CONFLICT
            );
        }

        category.setName(request.getName().trim());
        category.setDescription(request.getDescription());

        return CategoryMapper.toResponse(categoryRepository.save(category));
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(cacheNames = CacheConfig.CATEGORIES_ACTIVE_CACHE, allEntries = true),
            @CacheEvict(cacheNames = CacheConfig.BOOKS_ACTIVE_CACHE, allEntries = true),
            @CacheEvict(cacheNames = CacheConfig.BOOK_DETAIL_CACHE, allEntries = true)
    })
    public void softDeleteCategory(Long id, HttpServletRequest httpRequest) {
        RoleChecker.requireWriteRole(httpRequest);

        Category category = categoryRepository.findByIdAndIsActiveTrue(id)
                .orElseThrow(() -> new BusinessException(
                        "CATEGORY_NOT_FOUND",
                        "Category not found.",
                        HttpStatus.NOT_FOUND
                ));

        if (bookRepository.existsByCategoryIdAndIsActiveTrue(id)) {
            throw new BusinessException(
                    "CATEGORY_HAS_ACTIVE_BOOKS",
                    "Cannot delete category while active books still exist.",
                    HttpStatus.UNPROCESSABLE_ENTITY
            );
        }

        category.setIsActive(false);
        categoryRepository.save(category);
    }
}
