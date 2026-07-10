package com.booksphere.book.mapper;

import com.booksphere.book.dto.response.BookDetailResponse;
import com.booksphere.book.dto.response.BookResponse;
import com.booksphere.book.dto.response.InternalBookResponse;
import com.booksphere.book.entity.Book;

public final class BookMapper {

    private BookMapper() {
    }

    public static BookResponse toResponse(Book book) {
        BookResponse response = new BookResponse();
        response.setId(book.getId());
        response.setTitle(book.getTitle());
        response.setAuthor(book.getAuthor());
        response.setIsbn(book.getIsbn());
        response.setCategoryId(book.getCategory().getId());
        response.setCategoryName(book.getCategory().getName());
        response.setTotalQuantity(book.getTotalQuantity());
        response.setAvailableQuantity(book.getAvailableQuantity());
        response.setIsActive(book.getIsActive());
        return response;
    }

    public static BookDetailResponse toDetailResponse(Book book) {
        BookDetailResponse response = new BookDetailResponse();
        response.setId(book.getId());
        response.setTitle(book.getTitle());
        response.setAuthor(book.getAuthor());
        response.setIsbn(book.getIsbn());
        response.setPublisher(book.getPublisher());
        response.setPublishedYear(book.getPublishedYear());
        response.setCategoryId(book.getCategory().getId());
        response.setCategoryName(book.getCategory().getName());
        response.setTotalQuantity(book.getTotalQuantity());
        response.setAvailableQuantity(book.getAvailableQuantity());
        response.setDescription(book.getDescription());
        response.setIsActive(book.getIsActive());
        response.setCreatedAt(book.getCreatedAt());
        response.setUpdatedAt(book.getUpdatedAt());
        return response;
    }

    public static InternalBookResponse toInternalResponse(Book book) {
        InternalBookResponse response = new InternalBookResponse();
        response.setId(book.getId());
        response.setTitle(book.getTitle());
        response.setAuthor(book.getAuthor());
        response.setIsbn(book.getIsbn());
        response.setAvailableQuantity(book.getAvailableQuantity());
        response.setIsActive(book.getIsActive());
        response.setCategoryActive(book.getCategory().getIsActive());
        return response;
    }
}
