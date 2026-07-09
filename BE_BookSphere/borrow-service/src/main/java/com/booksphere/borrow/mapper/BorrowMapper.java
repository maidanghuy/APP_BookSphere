package com.booksphere.borrow.mapper;

import com.booksphere.borrow.dto.response.BorrowDetailResponse;
import com.booksphere.borrow.dto.response.BorrowItemResponse;
import com.booksphere.borrow.dto.response.BorrowResponse;
import com.booksphere.borrow.dto.response.InternalBorrowResponse;
import com.booksphere.borrow.dto.response.SagaLogResponse;
import com.booksphere.borrow.entity.Borrow;
import com.booksphere.borrow.entity.BorrowItem;
import com.booksphere.borrow.entity.SagaLog;
import java.util.List;
import org.springframework.stereotype.Component;

@Component
public class BorrowMapper {

    public BorrowResponse toResponse(Borrow borrow) {
        return new BorrowResponse(
                borrow.getId(),
                borrow.getUserId(),
                borrow.getBorrowDate(),
                borrow.getDueDate(),
                borrow.getReturnDate(),
                borrow.getStatus().name()
        );
    }

    public BorrowItemResponse toItemResponse(BorrowItem item) {
        return new BorrowItemResponse(
                item.getId(),
                item.getBookId(),
                item.getQuantity(),
                item.getStatus().name()
        );
    }

    public BorrowDetailResponse toDetailResponse(Borrow borrow, List<BorrowItem> items) {
        return new BorrowDetailResponse(
                borrow.getId(),
                borrow.getUserId(),
                borrow.getBorrowDate(),
                borrow.getDueDate(),
                borrow.getReturnDate(),
                borrow.getStatus().name(),
                items.stream().map(this::toItemResponse).toList()
        );
    }

    public InternalBorrowResponse toInternalResponse(Borrow borrow) {
        return new InternalBorrowResponse(
                borrow.getId(),
                borrow.getUserId(),
                borrow.getDueDate(),
                borrow.getReturnDate(),
                borrow.getStatus().name()
        );
    }

    public SagaLogResponse toSagaLogResponse(SagaLog sagaLog) {
        return new SagaLogResponse(
                sagaLog.getId(),
                sagaLog.getSagaId(),
                sagaLog.getBorrowId(),
                sagaLog.getTransactionType().name(),
                sagaLog.getCurrentStep(),
                sagaLog.getStatus().name(),
                sagaLog.getCompensationAction(),
                sagaLog.getErrorMessage(),
                sagaLog.getCreatedAt(),
                sagaLog.getUpdatedAt()
        );
    }
}
