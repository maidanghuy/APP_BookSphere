package com.booksphere.book.cache;

import com.booksphere.book.dto.response.BookResponse;
import com.booksphere.book.dto.response.PageResponse;

public class BookPageCacheValue {

    private PageResponse<BookResponse> page;

    public PageResponse<BookResponse> getPage() {
        return page;
    }

    public void setPage(PageResponse<BookResponse> page) {
        this.page = page;
    }
}
