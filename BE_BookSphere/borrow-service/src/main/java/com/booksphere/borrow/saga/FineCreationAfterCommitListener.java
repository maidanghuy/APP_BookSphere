package com.booksphere.borrow.saga;

import com.booksphere.borrow.client.FineServiceClient;
import com.booksphere.borrow.client.dto.FineCreateRequest;
import com.booksphere.borrow.entity.SagaLog;
import com.booksphere.borrow.repository.SagaLogRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

@Component
public class FineCreationAfterCommitListener {

    private static final Logger log = LoggerFactory.getLogger(FineCreationAfterCommitListener.class);

    private final FineServiceClient fineServiceClient;
    private final SagaLogRepository sagaLogRepository;

    public FineCreationAfterCommitListener(
            FineServiceClient fineServiceClient,
            SagaLogRepository sagaLogRepository
    ) {
        this.fineServiceClient = fineServiceClient;
        this.sagaLogRepository = sagaLogRepository;
    }

    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void createFineAfterBorrowCommit(FineCreationRequestedEvent event) {
        log.info(
                "Calling Fine Service after commit borrowId={} createdFrom={} sagaId={}",
                event.borrowId(),
                event.createdFrom(),
                event.sagaId()
        );

        try {
            fineServiceClient.createFine(new FineCreateRequest(
                    event.borrowId(),
                    event.userId(),
                    event.dueDate(),
                    event.effectiveDate(),
                    event.daysOverdue(),
                    event.createdFrom()
            ));
            log.info(
                    "Fine creation requested successfully borrowId={} createdFrom={} sagaId={}",
                    event.borrowId(),
                    event.createdFrom(),
                    event.sagaId()
            );
        } catch (Exception exception) {
            log.warn(
                    "Fine creation failed after commit borrowId={} createdFrom={} sagaId={}",
                    event.borrowId(),
                    event.createdFrom(),
                    event.sagaId(),
                    exception
            );
            appendSagaError(event.sagaId(), SagaErrorMessage.rootCause("Fine Service failed", exception));
        }
    }

    private void appendSagaError(String sagaId, String error) {
        sagaLogRepository.findBySagaId(sagaId)
                .ifPresentOrElse(
                        sagaLog -> saveSagaError(sagaLog, error),
                        () -> log.warn("Unable to append fine creation error because saga log was not found sagaId={}", sagaId)
                );
    }

    private void saveSagaError(SagaLog sagaLog, String error) {
        sagaLog.setErrorMessage(SagaErrorMessage.append(sagaLog.getErrorMessage(), error));
        sagaLogRepository.save(sagaLog);
    }
}
