package com.booksphere.fine.service;

import com.booksphere.fine.config.UserContext;
import com.booksphere.fine.dto.request.FineCreateRequest;
import com.booksphere.fine.dto.request.FineSearchRequest;
import com.booksphere.fine.dto.response.FineCreateResult;
import com.booksphere.fine.dto.response.FineResponse;
import com.booksphere.fine.dto.response.PageResponse;

public interface FineService {

    FineCreateResult createFineInternal(FineCreateRequest request);

    PageResponse<FineResponse> searchFines(FineSearchRequest request, UserContext userContext);

    FineResponse getFineById(Long fineId, UserContext userContext);
}
