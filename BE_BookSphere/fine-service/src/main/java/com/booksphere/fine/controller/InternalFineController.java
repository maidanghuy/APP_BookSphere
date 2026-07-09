package com.booksphere.fine.controller;

import com.booksphere.fine.dto.request.FineCreateRequest;
import com.booksphere.fine.dto.response.ApiResponse;
import com.booksphere.fine.dto.response.FineCreateResult;
import com.booksphere.fine.dto.response.FineResponse;
import com.booksphere.fine.service.FineService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/fines")
@Tag(name = "Internal Fine APIs", description = "Internal APIs for idempotent fine creation")
public class InternalFineController {

    private final FineService fineService;

    public InternalFineController(FineService fineService) {
        this.fineService = fineService;
    }

    @Operation(
            summary = "Create fine idempotently",
            description = "Internal service-to-service API. Do not expose this endpoint to external clients through API Gateway."
    )
    @io.swagger.v3.oas.annotations.responses.ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Fine created successfully"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Fine already exists"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Invalid request body"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Fine creation conflict"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "Unexpected server error")
    })
    @PostMapping
    public ResponseEntity<ApiResponse<FineResponse>> createFine(
            @Valid @RequestBody FineCreateRequest body,
            HttpServletRequest request
    ) {
        FineCreateResult result = fineService.createFineInternal(body);
        HttpStatus status = result.isCreated() ? HttpStatus.CREATED : HttpStatus.OK;
        String message = result.isCreated()
                ? "Fine created successfully."
                : "Fine already exists.";

        return ResponseEntity.status(status).body(ApiResponse.success(
                message,
                result.getFine(),
                request.getRequestURI(),
                status.value()
        ));
    }
}
