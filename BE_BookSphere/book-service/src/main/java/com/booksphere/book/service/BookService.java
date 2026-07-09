package com.booksphere.book.service;

import com.booksphere.book.dto.request.BookCreateRequest;
import com.booksphere.book.dto.request.BookSearchRequest;
import com.booksphere.book.dto.request.BookUpdateRequest;
import com.booksphere.book.dto.request.StockUpdateRequest;
import com.booksphere.book.dto.response.BookDetailResponse;
import com.booksphere.book.dto.response.BookResponse;
import com.booksphere.book.dto.response.InternalBookResponse;
import com.booksphere.book.dto.response.PageResponse;
import com.booksphere.book.dto.response.StockUpdateResponse;
import jakarta.servlet.http.HttpServletRequest;

public interface BookService {

    PageResponse<BookResponse> searchBooks(BookSearchRequest request);

    BookDetailResponse getActiveBookById(Long id);

    BookDetailResponse createBook(BookCreateRequest request, HttpServletRequest httpRequest);

    BookDetailResponse updateBook(Long id, BookUpdateRequest request, HttpServletRequest httpRequest);

    void softDeleteBook(Long id, HttpServletRequest httpRequest);

    InternalBookResponse getInternalBook(Long bookId);

    StockUpdateResponse decreaseStock(Long bookId, StockUpdateRequest request);

    StockUpdateResponse increaseStock(Long bookId, StockUpdateRequest request);
}
