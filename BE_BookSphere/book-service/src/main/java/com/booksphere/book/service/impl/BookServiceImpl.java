package com.booksphere.book.service.impl;

import com.booksphere.book.config.CacheConfig;
import com.booksphere.book.config.RoleChecker;
import com.booksphere.book.cache.BookDetailCacheValue;
import com.booksphere.book.cache.BookPageCacheValue;
import com.booksphere.book.dto.request.BookCreateRequest;
import com.booksphere.book.dto.request.BookSearchRequest;
import com.booksphere.book.dto.request.BookUpdateRequest;
import com.booksphere.book.dto.request.StockUpdateRequest;
import com.booksphere.book.dto.response.BookDetailResponse;
import com.booksphere.book.dto.response.BookResponse;
import com.booksphere.book.dto.response.InternalBookResponse;
import com.booksphere.book.dto.response.PageResponse;
import com.booksphere.book.dto.response.StockUpdateResponse;
import com.booksphere.book.entity.Book;
import com.booksphere.book.entity.BookStockTransaction;
import com.booksphere.book.entity.Category;
import com.booksphere.book.entity.enums.StockAction;
import com.booksphere.book.entity.enums.StockTransactionStatus;
import com.booksphere.book.exception.BusinessException;
import com.booksphere.book.mapper.BookMapper;
import com.booksphere.book.repository.BookRepository;
import com.booksphere.book.repository.BookStockTransactionRepository;
import com.booksphere.book.repository.CategoryRepository;
import com.booksphere.book.service.BookService;
import jakarta.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BookServiceImpl implements BookService {

    private static final Set<String> ALLOWED_SORT_FIELDS = Set.of(
            "id", "title", "author", "isbn", "createdAt", "updatedAt", "availableQuantity", "totalQuantity"
    );

    private static final Map<String, String> SORT_FIELD_MAPPING = Map.of(
            "createdat", "createdAt",
            "updatedat", "updatedAt",
            "availablequantity", "availableQuantity",
            "totalquantity", "totalQuantity"
    );

    private final BookRepository bookRepository;
    private final CategoryRepository categoryRepository;
    private final BookStockTransactionRepository stockTransactionRepository;

    @Lazy
    @Autowired
    private BookServiceImpl self;

    public BookServiceImpl(
            BookRepository bookRepository,
            CategoryRepository categoryRepository,
            BookStockTransactionRepository stockTransactionRepository
    ) {
        this.bookRepository = bookRepository;
        this.categoryRepository = categoryRepository;
        this.stockTransactionRepository = stockTransactionRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public PageResponse<BookResponse> searchBooks(BookSearchRequest request) {
        return self.searchBooksCached(request).getPage();
    }

    @Cacheable(
            cacheNames = CacheConfig.BOOKS_ACTIVE_CACHE,
            key = "'keyword=' + (#request.keyword == null ? '' : #request.keyword) "
                    + "+ '|categoryId=' + (#request.categoryId == null ? '' : #request.categoryId) "
                    + "+ '|page=' + #request.page "
                    + "+ '|size=' + #request.size "
                    + "+ '|sortBy=' + #request.sortBy "
                    + "+ '|sortDir=' + #request.sortDir",
            unless = "#result == null"
    )
    public BookPageCacheValue searchBooksCached(BookSearchRequest request) {
        Pageable pageable = buildPageable(request);
        String keyword = normalizeKeyword(request.getKeyword());

        Page<Book> bookPage = bookRepository.searchActiveBooks(keyword, request.getCategoryId(), pageable);

        PageResponse<BookResponse> response = new PageResponse<>();
        response.setContent(new ArrayList<>(bookPage.getContent().stream().map(BookMapper::toResponse).toList()));
        response.setPage(bookPage.getNumber());
        response.setSize(bookPage.getSize());
        response.setTotalElements(bookPage.getTotalElements());
        response.setTotalPages(bookPage.getTotalPages());

        BookPageCacheValue cacheValue = new BookPageCacheValue();
        cacheValue.setPage(response);
        return cacheValue;
    }

    @Override
    @Transactional(readOnly = true)
    public BookDetailResponse getActiveBookById(Long id) {
        return self.getActiveBookByIdCached(id).getBook();
    }

    @Cacheable(
            cacheNames = CacheConfig.BOOK_DETAIL_CACHE,
            key = "#id",
            unless = "#result == null"
    )
    public BookDetailCacheValue getActiveBookByIdCached(Long id) {
        Book book = findActiveBookWithActiveCategory(id);

        BookDetailCacheValue cacheValue = new BookDetailCacheValue();
        cacheValue.setBook(BookMapper.toDetailResponse(book));
        return cacheValue;
    }

    @Override
    @Transactional
    @CacheEvict(cacheNames = CacheConfig.BOOKS_ACTIVE_CACHE, allEntries = true)
    public BookDetailResponse createBook(BookCreateRequest request, HttpServletRequest httpRequest) {
        RoleChecker.requireWriteRole(httpRequest);

        if (bookRepository.existsByIsbn(request.getIsbn())) {
            throw new BusinessException(
                    "BOOK_ISBN_DUPLICATED",
                    "ISBN already exists.",
                    HttpStatus.CONFLICT
            );
        }

        Category category = getActiveCategory(request.getCategoryId());

        int availableQuantity = request.getAvailableQuantity() != null
                ? request.getAvailableQuantity()
                : request.getTotalQuantity();

        validateQuantities(request.getTotalQuantity(), availableQuantity);

        Book book = new Book();
        book.setTitle(request.getTitle().trim());
        book.setAuthor(request.getAuthor().trim());
        book.setIsbn(request.getIsbn().trim());
        book.setPublisher(request.getPublisher());
        book.setPublishedYear(request.getPublishedYear());
        book.setCategory(category);
        book.setTotalQuantity(request.getTotalQuantity());
        book.setAvailableQuantity(availableQuantity);
        book.setDescription(request.getDescription());
        book.setIsActive(true);

        return BookMapper.toDetailResponse(bookRepository.save(book));
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(cacheNames = CacheConfig.BOOKS_ACTIVE_CACHE, allEntries = true),
            @CacheEvict(cacheNames = CacheConfig.BOOK_DETAIL_CACHE, key = "#id")
    })
    public BookDetailResponse updateBook(Long id, BookUpdateRequest request, HttpServletRequest httpRequest) {
        RoleChecker.requireWriteRole(httpRequest);

        Book book = bookRepository.findById(id)
                .filter(existing -> Boolean.TRUE.equals(existing.getIsActive()))
                .orElseThrow(() -> new BusinessException(
                        "BOOK_NOT_FOUND",
                        "Book not found.",
                        HttpStatus.NOT_FOUND
                ));

        if (request.getIsbn() != null && !request.getIsbn().isBlank()) {
            String isbn = request.getIsbn().trim();
            if (bookRepository.existsByIsbnAndIdNot(isbn, id)) {
                throw new BusinessException(
                        "BOOK_ISBN_DUPLICATED",
                        "ISBN already exists.",
                        HttpStatus.CONFLICT
                );
            }
            book.setIsbn(isbn);
        }

        if (request.getTitle() != null && !request.getTitle().isBlank()) {
            book.setTitle(request.getTitle().trim());
        }

        if (request.getAuthor() != null && !request.getAuthor().isBlank()) {
            book.setAuthor(request.getAuthor().trim());
        }

        if (request.getPublisher() != null) {
            book.setPublisher(request.getPublisher());
        }

        if (request.getPublishedYear() != null) {
            book.setPublishedYear(request.getPublishedYear());
        }

        if (request.getDescription() != null) {
            book.setDescription(request.getDescription());
        }

        if (request.getCategoryId() != null) {
            book.setCategory(getActiveCategory(request.getCategoryId()));
        }

        Integer totalQuantity = request.getTotalQuantity() != null
                ? request.getTotalQuantity()
                : book.getTotalQuantity();
        Integer availableQuantity = request.getAvailableQuantity() != null
                ? request.getAvailableQuantity()
                : book.getAvailableQuantity();

        validateQuantities(totalQuantity, availableQuantity);
        book.setTotalQuantity(totalQuantity);
        book.setAvailableQuantity(availableQuantity);

        return BookMapper.toDetailResponse(bookRepository.save(book));
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(cacheNames = CacheConfig.BOOKS_ACTIVE_CACHE, allEntries = true),
            @CacheEvict(cacheNames = CacheConfig.BOOK_DETAIL_CACHE, key = "#id")
    })
    public void softDeleteBook(Long id, HttpServletRequest httpRequest) {
        RoleChecker.requireWriteRole(httpRequest);

        Book book = bookRepository.findById(id)
                .filter(existing -> Boolean.TRUE.equals(existing.getIsActive()))
                .orElseThrow(() -> new BusinessException(
                        "BOOK_NOT_FOUND",
                        "Book not found.",
                        HttpStatus.NOT_FOUND
                ));

        book.setIsActive(false);
        bookRepository.save(book);
    }

    @Override
    @Transactional(readOnly = true)
    public InternalBookResponse getInternalBook(Long bookId) {
        Book book = findActiveBookWithActiveCategory(bookId);
        return BookMapper.toInternalResponse(book);
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(cacheNames = CacheConfig.BOOKS_ACTIVE_CACHE, allEntries = true),
            @CacheEvict(cacheNames = CacheConfig.BOOK_DETAIL_CACHE, key = "#bookId")
    })
    public StockUpdateResponse decreaseStock(Long bookId, StockUpdateRequest request) {
        validateStockRequest(bookId, request);

        return processStockUpdate(bookId, request, StockAction.DECREASE);
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(cacheNames = CacheConfig.BOOKS_ACTIVE_CACHE, allEntries = true),
            @CacheEvict(cacheNames = CacheConfig.BOOK_DETAIL_CACHE, key = "#bookId")
    })
    public StockUpdateResponse increaseStock(Long bookId, StockUpdateRequest request) {
        validateStockRequest(bookId, request);

        return processStockUpdate(bookId, request, StockAction.INCREASE);
    }

    private StockUpdateResponse processStockUpdate(Long bookId, StockUpdateRequest request, StockAction action) {
        var existingTransaction = stockTransactionRepository
                .findBySagaIdAndBookIdAndAction(request.getSagaId(), bookId, action);

        if (existingTransaction.isPresent()) {
            BookStockTransaction transaction = existingTransaction.get();
            if (transaction.getStatus() == StockTransactionStatus.SUCCESS) {
                Book book = bookRepository.findById(bookId)
                        .orElseThrow(() -> new BusinessException(
                                "BOOK_NOT_FOUND",
                                "Book not found.",
                                HttpStatus.NOT_FOUND
                        ));
                return buildStockResponse(bookId, request.getSagaId(), action, transaction.getQuantity(),
                        book.getAvailableQuantity(), true);
            }

            throw buildStockConflictException(action);
        }

        int updatedRows = action == StockAction.DECREASE
                ? bookRepository.decreaseStock(bookId, request.getQuantity())
                : bookRepository.increaseStock(bookId, request.getQuantity());

        if (updatedRows == 0) {
            saveFailedTransaction(bookId, request, action);
            throw buildStockConflictException(action);
        }

        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new BusinessException(
                        "BOOK_NOT_FOUND",
                        "Book not found.",
                        HttpStatus.NOT_FOUND
                ));

        BookStockTransaction transaction = new BookStockTransaction();
        transaction.setSagaId(request.getSagaId());
        transaction.setBook(book);
        transaction.setAction(action);
        transaction.setQuantity(request.getQuantity());
        transaction.setStatus(StockTransactionStatus.SUCCESS);
        stockTransactionRepository.save(transaction);

        return buildStockResponse(bookId, request.getSagaId(), action, request.getQuantity(),
                book.getAvailableQuantity(), false);
    }

    private void saveFailedTransaction(Long bookId, StockUpdateRequest request, StockAction action) {
        bookRepository.findById(bookId).ifPresent(book -> {
            if (!stockTransactionRepository.existsBySagaIdAndBookIdAndAction(
                    request.getSagaId(), bookId, action)) {
                BookStockTransaction transaction = new BookStockTransaction();
                transaction.setSagaId(request.getSagaId());
                transaction.setBook(book);
                transaction.setAction(action);
                transaction.setQuantity(request.getQuantity());
                transaction.setStatus(StockTransactionStatus.FAILED);
                stockTransactionRepository.save(transaction);
            }
        });
    }

    private BusinessException buildStockConflictException(StockAction action) {
        if (action == StockAction.DECREASE) {
            return new BusinessException(
                    "BOOK_OUT_OF_STOCK",
                    "Book is inactive or out of stock.",
                    HttpStatus.CONFLICT
            );
        }

        return new BusinessException(
                "BOOK_INACTIVE",
                "Book is inactive or stock cannot be increased beyond total quantity.",
                HttpStatus.CONFLICT
        );
    }

    private StockUpdateResponse buildStockResponse(
            Long bookId,
            String sagaId,
            StockAction action,
            Integer quantity,
            Integer availableQuantity,
            boolean idempotent
    ) {
        StockUpdateResponse response = new StockUpdateResponse();
        response.setBookId(bookId);
        response.setSagaId(sagaId);
        response.setAction(action);
        response.setQuantity(quantity);
        response.setAvailableQuantity(availableQuantity);
        response.setIdempotent(idempotent);
        return response;
    }

    private void validateStockRequest(Long bookId, StockUpdateRequest request) {
        if (request.getBookId() != null && !request.getBookId().equals(bookId)) {
            throw new BusinessException(
                    "VALIDATION_FAILED",
                    "Book ID in path and body do not match.",
                    HttpStatus.BAD_REQUEST
            );
        }
    }

    private Book findActiveBookWithActiveCategory(Long id) {
        return bookRepository.findActiveBookWithActiveCategory(id)
                .orElseThrow(() -> new BusinessException(
                        "BOOK_NOT_FOUND",
                        "Book not found.",
                        HttpStatus.NOT_FOUND
                ));
    }

    private Category getActiveCategory(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new BusinessException(
                        "CATEGORY_NOT_FOUND",
                        "Category not found.",
                        HttpStatus.NOT_FOUND
                ));

        if (!Boolean.TRUE.equals(category.getIsActive())) {
            throw new BusinessException(
                    "CATEGORY_INACTIVE",
                    "Category is inactive.",
                    HttpStatus.UNPROCESSABLE_ENTITY
            );
        }

        return category;
    }

    private void validateQuantities(Integer totalQuantity, Integer availableQuantity) {
        if (totalQuantity < 0 || availableQuantity < 0) {
            throw new BusinessException(
                    "VALIDATION_FAILED",
                    "Quantities must not be negative.",
                    HttpStatus.BAD_REQUEST
            );
        }

        if (availableQuantity > totalQuantity) {
            throw new BusinessException(
                    "VALIDATION_FAILED",
                    "Available quantity cannot exceed total quantity.",
                    HttpStatus.BAD_REQUEST
            );
        }
    }

    private String normalizeKeyword(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return null;
        }
        return keyword.trim();
    }

    private Pageable buildPageable(BookSearchRequest request) {
        String sortField = resolveSortField(request.getSortBy());
        Sort.Direction direction = "desc".equalsIgnoreCase(request.getSortDir())
                ? Sort.Direction.DESC
                : Sort.Direction.ASC;
        int page = Math.max(request.getPage(), 0);
        int size = request.getSize() > 0 ? request.getSize() : 10;
        return PageRequest.of(page, size, Sort.by(direction, sortField));
    }

    private String resolveSortField(String sortBy) {
        if (sortBy == null || sortBy.isBlank()) {
            return "id";
        }

        String normalized = sortBy.trim();
        String mapped = SORT_FIELD_MAPPING.getOrDefault(normalized.toLowerCase(), normalized);

        if (!ALLOWED_SORT_FIELDS.contains(mapped)) {
            return "id";
        }

        return mapped;
    }
}
