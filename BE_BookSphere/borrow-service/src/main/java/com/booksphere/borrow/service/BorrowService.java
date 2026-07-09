package com.booksphere.borrow.service;

import com.booksphere.borrow.config.UserContext;
import com.booksphere.borrow.dto.request.BorrowCreateRequest;
import com.booksphere.borrow.dto.request.BorrowReturnRequest;
import com.booksphere.borrow.dto.request.BorrowSearchRequest;
import com.booksphere.borrow.dto.response.BorrowDetailResponse;
import com.booksphere.borrow.dto.response.BorrowResponse;
import com.booksphere.borrow.dto.response.InternalBorrowResponse;
import com.booksphere.borrow.dto.response.PageResponse;

public interface BorrowService {

    BorrowDetailResponse createBorrow(BorrowCreateRequest request, UserContext userContext);

    BorrowDetailResponse returnBorrow(Long borrowId, BorrowReturnRequest request, UserContext userContext);

    PageResponse<BorrowResponse> searchBorrows(BorrowSearchRequest request, UserContext userContext);

    BorrowDetailResponse getBorrow(Long borrowId, UserContext userContext);

    InternalBorrowResponse getInternalBorrow(Long borrowId);
}
