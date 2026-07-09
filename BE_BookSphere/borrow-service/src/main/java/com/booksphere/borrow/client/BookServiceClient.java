package com.booksphere.borrow.client;

import com.booksphere.borrow.client.dto.BookInternalResponse;
import com.booksphere.borrow.client.dto.ClientApiResponse;
import com.booksphere.borrow.client.dto.StockUpdateRequest;
import com.booksphere.borrow.client.dto.StockUpdateResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "book-service")
public interface BookServiceClient {

    @GetMapping("/internal/books/{bookId}")
    ClientApiResponse<BookInternalResponse> getInternalBook(@PathVariable Long bookId);

    @PutMapping("/internal/books/{bookId}/decrease-stock")
    ClientApiResponse<StockUpdateResponse> decreaseStock(
            @PathVariable Long bookId,
            @RequestBody StockUpdateRequest request
    );

    @PutMapping("/internal/books/{bookId}/increase-stock")
    ClientApiResponse<StockUpdateResponse> increaseStock(
            @PathVariable Long bookId,
            @RequestBody StockUpdateRequest request
    );
}
