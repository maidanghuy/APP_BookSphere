package com.booksphere.borrow.client;

import com.booksphere.borrow.client.dto.ClientApiResponse;
import com.booksphere.borrow.client.dto.FineCreateRequest;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient(name = "fine-service")
public interface FineServiceClient {

    @PostMapping("/internal/fines")
    ClientApiResponse<Object> createFine(@RequestBody FineCreateRequest request);
}
