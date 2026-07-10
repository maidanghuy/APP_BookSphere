package com.booksphere.borrow.mapper;

import com.booksphere.borrow.client.dto.BookInternalResponse;
import com.booksphere.borrow.client.dto.UserInternalResponse;
import com.booksphere.borrow.dto.response.BorrowDetailResponse;
import com.booksphere.borrow.dto.response.BorrowItemResponse;
import com.booksphere.borrow.dto.response.BorrowResponse;
import com.booksphere.borrow.dto.response.InternalBorrowResponse;
import com.booksphere.borrow.dto.response.SagaLogResponse;
import com.booksphere.borrow.entity.Borrow;
import com.booksphere.borrow.entity.BorrowItem;
import com.booksphere.borrow.entity.SagaLog;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Component;

@Component
public class BorrowMapper {

    public BorrowResponse toResponse(Borrow borrow) {
        return toResponse(borrow, null, null);
    }

    public BorrowResponse toResponse(Borrow borrow, Integer totalItems, UserInternalResponse user) {
        return new BorrowResponse(
                borrow.getId(),
                borrow.getUserId(),
                username(user),
                memberName(user),
                totalItems,
                borrow.getBorrowDate(),
                borrow.getDueDate(),
                borrow.getReturnDate(),
                borrow.getStatus().name()
        );
    }

    public BorrowItemResponse toItemResponse(BorrowItem item) {
        return toItemResponse(item, null);
    }

    public BorrowItemResponse toItemResponse(BorrowItem item, BookInternalResponse book) {
        return new BorrowItemResponse(
                item.getId(),
                item.getBookId(),
                book == null ? null : book.getTitle(),
                book == null ? null : book.getAuthor(),
                book == null ? null : book.getIsbn(),
                item.getQuantity(),
                item.getStatus().name()
        );
    }

    public BorrowDetailResponse toDetailResponse(Borrow borrow, List<BorrowItem> items) {
        return toDetailResponse(borrow, items, null, Map.of());
    }

    public BorrowDetailResponse toDetailResponse(
            Borrow borrow,
            List<BorrowItem> items,
            UserInternalResponse user,
            Map<Long, BookInternalResponse> booksById
    ) {
        return new BorrowDetailResponse(
                borrow.getId(),
                borrow.getUserId(),
                username(user),
                memberName(user),
                totalItems(items),
                borrow.getBorrowDate(),
                borrow.getDueDate(),
                borrow.getReturnDate(),
                borrow.getStatus().name(),
                items.stream()
                        .map(item -> toItemResponse(item, booksById.get(item.getBookId())))
                        .toList()
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

    private Integer totalItems(List<BorrowItem> items) {
        return items.stream()
                .map(BorrowItem::getQuantity)
                .filter(quantity -> quantity != null)
                .mapToInt(Integer::intValue)
                .sum();
    }

    private String username(UserInternalResponse user) {
        return user == null ? null : user.getUsername();
    }

    private String memberName(UserInternalResponse user) {
        if (user == null) {
            return null;
        }
        if (user.getFullName() != null && !user.getFullName().isBlank()) {
            return user.getFullName();
        }
        return user.getUsername();
    }
}
