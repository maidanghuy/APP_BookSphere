package com.booksphere.book.cache;

import com.booksphere.book.dto.response.BookDetailResponse;

public class BookDetailCacheValue {

    private BookDetailResponse book;

    public BookDetailResponse getBook() {
        return book;
    }

    public void setBook(BookDetailResponse book) {
        this.book = book;
    }
}
