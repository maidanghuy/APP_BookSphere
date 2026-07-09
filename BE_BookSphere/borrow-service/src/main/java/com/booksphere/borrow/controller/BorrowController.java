package com.booksphere.borrow.controller;

import com.booksphere.borrow.config.OpenApiConfig;
import com.booksphere.borrow.config.UserContext;
import com.booksphere.borrow.dto.request.BorrowCreateRequest;
import com.booksphere.borrow.dto.request.BorrowReturnRequest;
import com.booksphere.borrow.dto.request.BorrowSearchRequest;
import com.booksphere.borrow.dto.response.ApiResponse;
import com.booksphere.borrow.dto.response.BorrowDetailResponse;
import com.booksphere.borrow.dto.response.BorrowResponse;
import com.booksphere.borrow.dto.response.PageResponse;
import com.booksphere.borrow.entity.enums.BorrowStatus;
import com.booksphere.borrow.exception.BusinessException;
import com.booksphere.borrow.service.BorrowService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import java.time.LocalDateTime;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/borrows")
@Tag(name = "Borrows", description = "APIs for borrowing, returning and searching borrow records")
@SecurityRequirement(name = OpenApiConfig.SECURITY_SCHEME_NAME)
public class BorrowController {

    private final BorrowService borrowService;

    public BorrowController(BorrowService borrowService) {
        this.borrowService = borrowService;
    }

    @Operation(
            summary = "Create borrow",
            description = "Create a borrow record and orchestrate the borrow Saga. Requires JWT through API Gateway, which forwards X-User-* headers."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Borrow created successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request body"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT/user context"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "Insufficient role"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Book inactive, unavailable, or Saga conflict"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "503", description = "Downstream service unavailable")
    })
    @PostMapping
    public ResponseEntity<ApiResponse<BorrowDetailResponse>> createBorrow(
            @Valid @RequestBody BorrowCreateRequest request,
            @RequestHeader(value = "X-User-Id", required = false) String userId,
            @RequestHeader(value = "X-Username", required = false) String username,
            @RequestHeader(value = "X-User-Email", required = false) String email,
            @RequestHeader(value = "X-User-Role", required = false) String roles,
            HttpServletRequest servletRequest
    ) {
        BorrowDetailResponse responseBody = borrowService.createBorrow(
                request,
                userContext(userId, username, email, roles)
        );
        ApiResponse<BorrowDetailResponse> response = ApiResponse.success(
                "Borrow created successfully.",
                responseBody,
                servletRequest.getRequestURI(),
                HttpStatus.CREATED.value()
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @Operation(
            summary = "Return borrow",
            description = "Return a borrow record and orchestrate return stock, fine, and notification Saga steps."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Borrow returned successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request body"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT/user context"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "User cannot return this borrow"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Borrow not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Borrow was already returned"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "503", description = "Downstream service unavailable")
    })
    @PostMapping("/{borrowId}/return")
    public ResponseEntity<ApiResponse<BorrowDetailResponse>> returnBorrow(
            @PathVariable Long borrowId,
            @RequestBody(required = false) BorrowReturnRequest request,
            @RequestHeader(value = "X-User-Id", required = false) String userId,
            @RequestHeader(value = "X-Username", required = false) String username,
            @RequestHeader(value = "X-User-Email", required = false) String email,
            @RequestHeader(value = "X-User-Role", required = false) String roles,
            HttpServletRequest servletRequest
    ) {
        BorrowReturnRequest returnRequest = request == null ? new BorrowReturnRequest(null) : request;
        BorrowDetailResponse responseBody = borrowService.returnBorrow(
                borrowId,
                returnRequest,
                userContext(userId, username, email, roles)
        );
        ApiResponse<BorrowDetailResponse> response = ApiResponse.success(
                "Borrow returned successfully.",
                responseBody,
                servletRequest.getRequestURI(),
                HttpStatus.OK.value()
        );

        return ResponseEntity.ok(response);
    }

    @Operation(
            summary = "Search borrows",
            description = "Search borrow records by user, status, and date range with pagination. Normal users can only see their own records."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Borrows retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request parameter"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT/user context"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "User cannot view requested borrows"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<BorrowResponse>>> searchBorrows(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) BorrowStatus status,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime fromDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime toDate,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir,
            @RequestHeader(value = "X-User-Id", required = false) String headerUserId,
            @RequestHeader(value = "X-Username", required = false) String username,
            @RequestHeader(value = "X-User-Email", required = false) String email,
            @RequestHeader(value = "X-User-Role", required = false) String roles,
            HttpServletRequest servletRequest
    ) {
        BorrowSearchRequest searchRequest = new BorrowSearchRequest(
                userId,
                status,
                fromDate,
                toDate,
                page,
                size,
                sortBy,
                sortDir
        );
        PageResponse<BorrowResponse> responseBody = borrowService.searchBorrows(
                searchRequest,
                userContext(headerUserId, username, email, roles)
        );
        ApiResponse<PageResponse<BorrowResponse>> response = ApiResponse.success(
                "Borrows retrieved successfully.",
                responseBody,
                servletRequest.getRequestURI(),
                HttpStatus.OK.value()
        );

        return ResponseEntity.ok(response);
    }

    @Operation(
            summary = "Get borrow detail",
            description = "Get a borrow record by ID. Normal users can only view their own records."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Borrow retrieved successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "Missing or invalid JWT/user context"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "403", description = "User cannot view this borrow"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Borrow not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @GetMapping("/{borrowId}")
    public ResponseEntity<ApiResponse<BorrowDetailResponse>> getBorrow(
            @PathVariable Long borrowId,
            @RequestHeader(value = "X-User-Id", required = false) String userId,
            @RequestHeader(value = "X-Username", required = false) String username,
            @RequestHeader(value = "X-User-Email", required = false) String email,
            @RequestHeader(value = "X-User-Role", required = false) String roles,
            HttpServletRequest servletRequest
    ) {
        BorrowDetailResponse responseBody = borrowService.getBorrow(
                borrowId,
                userContext(userId, username, email, roles)
        );
        ApiResponse<BorrowDetailResponse> response = ApiResponse.success(
                "Borrow retrieved successfully.",
                responseBody,
                servletRequest.getRequestURI(),
                HttpStatus.OK.value()
        );

        return ResponseEntity.ok(response);
    }

    private UserContext userContext(String userId, String username, String email, String roles) {
        if (userId == null || userId.isBlank()) {
            throw new BusinessException("AUTH_TOKEN_MISSING", "Missing user context.", HttpStatus.UNAUTHORIZED);
        }

        try {
            return UserContext.fromHeaders(userId, username, email, roles);
        } catch (NumberFormatException exception) {
            throw new BusinessException("AUTH_TOKEN_INVALID", "Invalid user context.", HttpStatus.UNAUTHORIZED);
        }
    }
}
