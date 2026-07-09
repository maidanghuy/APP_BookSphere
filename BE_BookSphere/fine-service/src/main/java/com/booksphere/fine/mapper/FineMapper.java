package com.booksphere.fine.mapper;

import com.booksphere.fine.dto.response.FinePaymentResponse;
import com.booksphere.fine.dto.response.FineResponse;
import com.booksphere.fine.entity.Fine;
import com.booksphere.fine.entity.FinePayment;

public final class FineMapper {

    private FineMapper() {
    }

    public static FineResponse toResponse(Fine fine) {
        FineResponse response = new FineResponse();
        response.setId(fine.getId());
        response.setUserId(fine.getUserId());
        response.setBorrowId(fine.getBorrowId());
        response.setAmount(fine.getAmount());
        response.setCreatedFrom(fine.getCreatedFrom());
        response.setReason(fine.getReason());
        response.setStatus(fine.getStatus());
        response.setCreatedAt(fine.getCreatedAt());
        response.setPaidAt(fine.getPaidAt());
        return response;
    }

    public static FinePaymentResponse toPaymentResponse(FinePayment payment) {
        FinePaymentResponse response = new FinePaymentResponse();
        response.setId(payment.getId());
        response.setFineId(payment.getFine().getId());
        response.setAmount(payment.getAmount());
        response.setPaymentMethod(payment.getPaymentMethod());
        response.setPaymentStatus(payment.getPaymentStatus());
        response.setPaidAt(payment.getPaidAt());
        return response;
    }
}
