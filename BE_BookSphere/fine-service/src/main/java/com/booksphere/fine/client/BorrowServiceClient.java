package com.booksphere.fine.client;

import com.booksphere.fine.client.dto.ClientApiResponse;
import com.booksphere.fine.dto.response.BorrowInternalResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "borrow-service")
public interface BorrowServiceClient {

    @GetMapping("/internal/borrows/{borrowId}")
    ClientApiResponse<BorrowInternalResponse> getInternalBorrow(@PathVariable("borrowId") Long borrowId);
}
