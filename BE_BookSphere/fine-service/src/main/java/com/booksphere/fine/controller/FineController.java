package com.booksphere.fine.controller;

import com.booksphere.fine.config.OpenApiConfig;
import com.booksphere.fine.config.RoleChecker;
import com.booksphere.fine.config.UserContext;
import com.booksphere.fine.dto.request.FinePaymentRequest;
import com.booksphere.fine.dto.request.FineSearchRequest;
import com.booksphere.fine.dto.response.ApiResponse;
import com.booksphere.fine.dto.response.FinePaymentResponse;
import com.booksphere.fine.dto.response.FineResponse;
import com.booksphere.fine.dto.response.PageResponse;
import com.booksphere.fine.service.FinePaymentService;
import com.booksphere.fine.service.FineService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/fines")
@Tag(name = "Fines", description = "APIs for viewing and paying fines")
@SecurityRequirement(name = OpenApiConfig.SECURITY_SCHEME_NAME)
public class FineController {

    private final FineService fineService;
    private final FinePaymentService finePaymentService;

    public FineController(FineService fineService, FinePaymentService finePaymentService) {
        this.fineService = fineService;
        this.finePaymentService = finePaymentService;
    }

    @Operation(
            summary = "Search fines",
            description = "Search fines by user, borrow, and status. Requires JWT through API Gateway, which forwards X-User-* headers."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Fines retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request parameter"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT/user context"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "User cannot view requested fines"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<FineResponse>>> searchFines(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Long borrowId,
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir,
            HttpServletRequest request
    ) {
        UserContext userContext = UserContext.fromRequest(request);
        RoleChecker.requireReadAccess(userContext);

        FineSearchRequest searchRequest = new FineSearchRequest();
        searchRequest.setUserId(userId);
        searchRequest.setBorrowId(borrowId);
        searchRequest.setStatus(status);
        searchRequest.setPage(page);
        searchRequest.setSize(size);
        searchRequest.setSortBy(sortBy);
        searchRequest.setSortDir(sortDir);

        PageResponse<FineResponse> fines = fineService.searchFines(searchRequest, userContext);
        return ResponseEntity.ok(ApiResponse.success(
                "Fines retrieved successfully.",
                fines,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Get fine detail",
            description = "Get a fine by ID. Normal users can only view their own fines."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Fine retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT/user context"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "User cannot view this fine"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Fine not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping("/{fineId}")
    public ResponseEntity<ApiResponse<FineResponse>> getFineById(
            @PathVariable Long fineId,
            HttpServletRequest request
    ) {
        UserContext userContext = UserContext.fromRequest(request);
        RoleChecker.requireReadAccess(userContext);

        FineResponse fine = fineService.getFineById(fineId, userContext);
        return ResponseEntity.ok(ApiResponse.success(
                "Fine retrieved successfully.",
                fine,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }

    @Operation(
            summary = "Pay fine",
            description = "Pay an unpaid fine. Requires JWT through API Gateway, which forwards X-User-* headers."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Fine payment processed successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request body"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT/user context"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "User cannot pay this fine"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Fine not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Fine is already paid or payment is invalid")
    })
    @PostMapping("/{fineId}/pay")
    public ResponseEntity<ApiResponse<FinePaymentResponse>> payFine(
            @PathVariable Long fineId,
            @Valid @RequestBody FinePaymentRequest body,
            HttpServletRequest request
    ) {
        UserContext userContext = UserContext.fromRequest(request);
        RoleChecker.requirePaymentAccess(userContext);

        FinePaymentResponse payment = finePaymentService.payFine(fineId, body, userContext);
        return ResponseEntity.ok(ApiResponse.success(
                "Fine payment processed successfully.",
                payment,
                request.getRequestURI(),
                HttpStatus.OK.value()
        ));
    }
}
