package com.booksphere.fine.service;

import com.booksphere.fine.config.UserContext;
import com.booksphere.fine.dto.request.FinePaymentRequest;
import com.booksphere.fine.dto.response.FinePaymentResponse;

public interface FinePaymentService {

    FinePaymentResponse payFine(Long fineId, FinePaymentRequest request, UserContext userContext);
}
