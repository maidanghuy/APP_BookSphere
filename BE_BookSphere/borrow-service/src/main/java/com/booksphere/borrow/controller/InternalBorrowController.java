package com.booksphere.borrow.controller;

import com.booksphere.borrow.dto.response.ApiResponse;
import com.booksphere.borrow.dto.response.InternalBorrowResponse;
import com.booksphere.borrow.service.BorrowService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/borrows")
@Tag(name = "Internal Borrow APIs", description = "Internal APIs for service-to-service borrow lookup")
public class InternalBorrowController {

    private final BorrowService borrowService;

    public InternalBorrowController(BorrowService borrowService) {
        this.borrowService = borrowService;
    }

    @Operation(
            summary = "Get internal borrow snapshot",
            description = "Internal service-to-service API. Do not expose this endpoint to external clients through API Gateway."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Borrow retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Borrow not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping("/{borrowId}")
    public ResponseEntity<ApiResponse<InternalBorrowResponse>> getInternalBorrow(
            @PathVariable Long borrowId,
            HttpServletRequest servletRequest
    ) {
        InternalBorrowResponse responseBody = borrowService.getInternalBorrow(borrowId);
        ApiResponse<InternalBorrowResponse> response = ApiResponse.success(
                "Borrow retrieved successfully.",
                responseBody,
                servletRequest.getRequestURI(),
                HttpStatus.OK.value()
        );

        return ResponseEntity.ok(response);
    }
}
