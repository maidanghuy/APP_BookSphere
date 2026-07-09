package com.booksphere.borrow.saga;

import com.booksphere.borrow.client.BookServiceClient;
import com.booksphere.borrow.client.dto.StockUpdateRequest;
import com.booksphere.borrow.dto.request.BorrowItemRequest;
import com.booksphere.borrow.entity.SagaLog;
import com.booksphere.borrow.entity.enums.SagaStatus;
import com.booksphere.borrow.repository.SagaLogRepository;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class CompensationService {

    private static final Logger log = LoggerFactory.getLogger(CompensationService.class);

    private final BookServiceClient bookServiceClient;
    private final SagaLogRepository sagaLogRepository;

    public CompensationService(BookServiceClient bookServiceClient, SagaLogRepository sagaLogRepository) {
        this.bookServiceClient = bookServiceClient;
        this.sagaLogRepository = sagaLogRepository;
    }

    public void compensateDecreaseStock(String sagaId, List<BorrowItemRequest> decreasedItems, SagaLog sagaLog) {
        if (decreasedItems.isEmpty()) {
            return;
        }

        sagaLog.setStatus(SagaStatus.COMPENSATING);
        sagaLog.setCurrentStep(BorrowSagaStep.INCREASE_STOCK.name());
        sagaLog.setCompensationAction("Increasing stock for " + decreasedItems.size() + " decreased item(s).");
        sagaLogRepository.save(sagaLog);

        String compensationSagaId = "COMPENSATE-" + sagaId;
        for (BorrowItemRequest item : decreasedItems) {
            try {
                bookServiceClient.increaseStock(
                        item.bookId(),
                        new StockUpdateRequest(compensationSagaId, item.bookId(), item.quantity())
                );
            } catch (Exception exception) {
                log.warn("Compensation failed for sagaId={}, bookId={}", sagaId, item.bookId(), exception);
                appendSagaError(sagaLog, SagaErrorMessage.rootCause(
                        "Compensation failed bookId=" + item.bookId(),
                        exception
                ));
            }
        }

        sagaLog.setStatus(SagaStatus.COMPENSATED);
        sagaLogRepository.save(sagaLog);
    }

    private void appendSagaError(SagaLog sagaLog, String error) {
        sagaLog.setErrorMessage(SagaErrorMessage.append(sagaLog.getErrorMessage(), error));
    }
}
