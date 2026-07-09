package com.booksphere.borrow.saga;

import com.booksphere.borrow.client.BookServiceClient;
import com.booksphere.borrow.client.FineServiceClient;
import com.booksphere.borrow.client.NotificationServiceClient;
import com.booksphere.borrow.client.dto.BookInternalResponse;
import com.booksphere.borrow.client.dto.ClientApiResponse;
import com.booksphere.borrow.client.dto.FineCreateRequest;
import com.booksphere.borrow.client.dto.NotificationCreateRequest;
import com.booksphere.borrow.client.dto.StockUpdateRequest;
import com.booksphere.borrow.config.UserContext;
import com.booksphere.borrow.dto.request.BorrowCreateRequest;
import com.booksphere.borrow.dto.request.BorrowItemRequest;
import com.booksphere.borrow.dto.request.BorrowReturnRequest;
import com.booksphere.borrow.dto.response.BorrowDetailResponse;
import com.booksphere.borrow.entity.Borrow;
import com.booksphere.borrow.entity.BorrowItem;
import com.booksphere.borrow.entity.SagaLog;
import com.booksphere.borrow.entity.enums.BorrowItemStatus;
import com.booksphere.borrow.entity.enums.BorrowStatus;
import com.booksphere.borrow.entity.enums.SagaStatus;
import com.booksphere.borrow.entity.enums.SagaTransactionType;
import com.booksphere.borrow.exception.BusinessException;
import com.booksphere.borrow.mapper.BorrowMapper;
import com.booksphere.borrow.repository.BorrowItemRepository;
import com.booksphere.borrow.repository.BorrowRepository;
import com.booksphere.borrow.repository.SagaLogRepository;
import feign.FeignException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BorrowSagaOrchestrator {

    private static final Logger log = LoggerFactory.getLogger(BorrowSagaOrchestrator.class);

    private final BookServiceClient bookServiceClient;
    private final FineServiceClient fineServiceClient;
    private final NotificationServiceClient notificationServiceClient;
    private final CompensationService compensationService;
    private final BorrowRepository borrowRepository;
    private final BorrowItemRepository borrowItemRepository;
    private final SagaLogRepository sagaLogRepository;
    private final BorrowMapper borrowMapper;

    public BorrowSagaOrchestrator(
            BookServiceClient bookServiceClient,
            FineServiceClient fineServiceClient,
            NotificationServiceClient notificationServiceClient,
            CompensationService compensationService,
            BorrowRepository borrowRepository,
            BorrowItemRepository borrowItemRepository,
            SagaLogRepository sagaLogRepository,
            BorrowMapper borrowMapper
    ) {
        this.bookServiceClient = bookServiceClient;
        this.fineServiceClient = fineServiceClient;
        this.notificationServiceClient = notificationServiceClient;
        this.compensationService = compensationService;
        this.borrowRepository = borrowRepository;
        this.borrowItemRepository = borrowItemRepository;
        this.sagaLogRepository = sagaLogRepository;
        this.borrowMapper = borrowMapper;
    }

    @Transactional(noRollbackFor = BusinessException.class)
    public BorrowDetailResponse borrowBooks(BorrowCreateRequest request, UserContext userContext) {
        String sagaId = "BORROW-" + UUID.randomUUID();
        SagaLog sagaLog = createSagaLog(sagaId, SagaTransactionType.BORROW_BOOK, BorrowSagaStep.CHECK_BOOK);
        List<BorrowItemRequest> decreasedItems = new ArrayList<>();

        try {
            for (BorrowItemRequest item : request.items()) {
                updateStep(sagaLog, BorrowSagaStep.CHECK_BOOK);
                validateBookCanBeBorrowed(item.bookId());

                updateStep(sagaLog, BorrowSagaStep.DECREASE_STOCK);
                decreaseStock(sagaId, item);
                decreasedItems.add(item);
            }

            updateStep(sagaLog, BorrowSagaStep.CREATE_BORROW);
            Borrow borrow = borrowRepository.save(new Borrow(
                    userContext.userId(),
                    LocalDateTime.now(),
                    request.dueDate(),
                    BorrowStatus.BORROWING
            ));

            List<BorrowItem> items = request.items().stream()
                    .map(item -> new BorrowItem(borrow, item.bookId(), item.quantity(), BorrowItemStatus.BORROWED))
                    .toList();
            List<BorrowItem> savedItems = borrowItemRepository.saveAll(items);

            sagaLog.setBorrowId(borrow.getId());
            updateStep(sagaLog, BorrowSagaStep.SEND_NOTIFICATION);
            sendNotificationBestEffort(
                    sagaLog,
                    new NotificationCreateRequest(
                            borrow.getUserId(),
                            "Borrow created",
                            "Your borrow request has been created successfully.",
                            "BORROW",
                            borrow.getId(),
                            "BORROW_CREATED_" + borrow.getId()
                    )
            );

            sagaLog.setStatus(SagaStatus.COMPLETED);
            sagaLogRepository.save(sagaLog);
            return borrowMapper.toDetailResponse(borrow, savedItems);
        } catch (BusinessException exception) {
            sagaLog.setStatus(SagaStatus.FAILED);
            sagaLog.setErrorMessage(SagaErrorMessage.business(exception));
            sagaLogRepository.save(sagaLog);
            compensationService.compensateDecreaseStock(sagaId, decreasedItems, sagaLog);
            throw exception;
        } catch (Exception exception) {
            sagaLog.setStatus(SagaStatus.FAILED);
            sagaLog.setErrorMessage(SagaErrorMessage.rootCause("Borrow saga failed", exception));
            sagaLogRepository.save(sagaLog);
            compensationService.compensateDecreaseStock(sagaId, decreasedItems, sagaLog);
            throw new BusinessException(
                    "BORROW_SAGA_FAILED",
                    "Borrow saga failed and compensation was triggered.",
                    HttpStatus.INTERNAL_SERVER_ERROR
            );
        }
    }

    @Transactional(noRollbackFor = BusinessException.class)
    public BorrowDetailResponse returnBooks(Borrow borrow, BorrowReturnRequest request) {
        if (BorrowStatus.RETURNED.equals(borrow.getStatus())) {
            SagaLog sagaLog = createSagaLog(
                    "RETURN-REJECTED-" + borrow.getId() + "-" + UUID.randomUUID(),
                    SagaTransactionType.RETURN_BOOK,
                    BorrowSagaStep.UPDATE_BORROW_RETURNED
            );
            sagaLog.setBorrowId(borrow.getId());
            markFailed(sagaLog, "Borrow is already returned.");
            throw new BusinessException(
                    "BORROW_ALREADY_RETURNED",
                    "Borrow is already returned.",
                    HttpStatus.UNPROCESSABLE_ENTITY
            );
        }

        if (!BorrowStatus.BORROWING.equals(borrow.getStatus()) && !BorrowStatus.OVERDUE.equals(borrow.getStatus())) {
            SagaLog sagaLog = createSagaLog(
                    "RETURN-REJECTED-" + borrow.getId() + "-" + UUID.randomUUID(),
                    SagaTransactionType.RETURN_BOOK,
                    BorrowSagaStep.UPDATE_BORROW_RETURNED
            );
            sagaLog.setBorrowId(borrow.getId());
            markFailed(sagaLog, "Borrow cannot be returned from status " + borrow.getStatus() + ".");
            throw new BusinessException(
                    "BORROW_NOT_ALLOWED",
                    "Borrow cannot be returned from current status.",
                    HttpStatus.CONFLICT
            );
        }

        String sagaId = "RETURN-" + borrow.getId();
        SagaLog sagaLog = getOrCreateSagaLog(sagaId, SagaTransactionType.RETURN_BOOK, BorrowSagaStep.INCREASE_STOCK);
        sagaLog.setBorrowId(borrow.getId());
        sagaLog.setStatus(SagaStatus.STARTED);
        sagaLogRepository.save(sagaLog);

        List<BorrowItem> items = borrowItemRepository.findByBorrow_Id(borrow.getId());
        LocalDateTime returnDate = request.returnDate() == null ? LocalDateTime.now() : request.returnDate();
        boolean lateReturn = returnDate.isAfter(borrow.getDueDate()) || BorrowStatus.OVERDUE.equals(borrow.getStatus());

        try {
            for (BorrowItem item : items) {
                bookServiceClient.increaseStock(
                        item.getBookId(),
                        new StockUpdateRequest(sagaId, item.getBookId(), item.getQuantity())
                );
            }

            updateStep(sagaLog, BorrowSagaStep.UPDATE_BORROW_RETURNED);
            borrow.setReturnDate(returnDate);
            borrow.setStatus(BorrowStatus.RETURNED);
            Borrow savedBorrow = borrowRepository.save(borrow);
            items.forEach(item -> item.setStatus(BorrowItemStatus.RETURNED));
            List<BorrowItem> savedItems = borrowItemRepository.saveAll(items);

            if (lateReturn) {
                updateStep(sagaLog, BorrowSagaStep.CREATE_FINE);
                createFineBestEffort(sagaLog, savedBorrow, returnDate, "LATE_RETURN");
            }

            updateStep(sagaLog, BorrowSagaStep.SEND_NOTIFICATION);
            sendNotificationBestEffort(
                    sagaLog,
                    new NotificationCreateRequest(
                            savedBorrow.getUserId(),
                            "Borrow returned",
                            "Your borrowed books have been returned successfully.",
                            "RETURN",
                            savedBorrow.getId(),
                            "BORROW_RETURNED_" + savedBorrow.getId()
                    )
            );

            sagaLog.setStatus(SagaStatus.COMPLETED);
            sagaLogRepository.save(sagaLog);
            return borrowMapper.toDetailResponse(savedBorrow, savedItems);
        } catch (FeignException exception) {
            markFailed(sagaLog, SagaErrorMessage.rootCause("Book stock increase failed", exception));
            throw downstreamUnavailable();
        }
    }

    @Transactional
    public void markBorrowOverdue(Borrow borrow) {
        String sagaId = "OVERDUE-" + borrow.getId() + "-" + UUID.randomUUID();
        SagaLog sagaLog = createSagaLog(sagaId, SagaTransactionType.OVERDUE_BORROW, BorrowSagaStep.MARK_OVERDUE);
        sagaLog.setBorrowId(borrow.getId());

        borrow.setStatus(BorrowStatus.OVERDUE);
        borrowRepository.save(borrow);

        updateStep(sagaLog, BorrowSagaStep.CREATE_FINE);
        createFineBestEffort(sagaLog, borrow, LocalDateTime.now(), "OVERDUE_SCHEDULER");

        updateStep(sagaLog, BorrowSagaStep.SEND_NOTIFICATION);
        sendNotificationBestEffort(
                sagaLog,
                new NotificationCreateRequest(
                        borrow.getUserId(),
                        "Borrow overdue",
                        "Your borrow is overdue.",
                        "OVERDUE",
                        borrow.getId(),
                        "BORROW_OVERDUE_" + borrow.getId()
                )
        );

        sagaLog.setStatus(SagaStatus.COMPLETED);
        sagaLogRepository.save(sagaLog);
    }

    @Transactional(noRollbackFor = Exception.class)
    public void sendDueSoonNotification(Borrow borrow) {
        SagaLog sagaLog = createSagaLog(
                "DUE-SOON-" + borrow.getId() + "-" + UUID.randomUUID(),
                SagaTransactionType.OVERDUE_BORROW,
                BorrowSagaStep.SEND_NOTIFICATION
        );
        sagaLog.setBorrowId(borrow.getId());
        sendNotificationBestEffort(
                sagaLog,
                new NotificationCreateRequest(
                        borrow.getUserId(),
                        "Borrow due soon",
                        "Your borrow is due soon.",
                        "DUE_SOON",
                        borrow.getId(),
                        "BORROW_DUE_SOON_" + borrow.getId()
                )
        );
        sagaLog.setStatus(SagaStatus.COMPLETED);
        sagaLogRepository.save(sagaLog);
    }

    private SagaLog createSagaLog(String sagaId, SagaTransactionType transactionType, BorrowSagaStep step) {
        SagaLog sagaLog = new SagaLog(sagaId, transactionType, step.name(), SagaStatus.STARTED);
        return sagaLogRepository.save(sagaLog);
    }

    private SagaLog getOrCreateSagaLog(String sagaId, SagaTransactionType transactionType, BorrowSagaStep step) {
        return sagaLogRepository.findBySagaId(sagaId)
                .orElseGet(() -> createSagaLog(sagaId, transactionType, step));
    }

    private void updateStep(SagaLog sagaLog, BorrowSagaStep step) {
        sagaLog.setCurrentStep(step.name());
        sagaLogRepository.save(sagaLog);
    }

    private void validateBookCanBeBorrowed(Long bookId) {
        try {
            ClientApiResponse<BookInternalResponse> response = bookServiceClient.getInternalBook(bookId);
            BookInternalResponse book = response.getData();
            if (book == null) {
                throw new BusinessException("BOOK_NOT_FOUND", "Book not found.", HttpStatus.NOT_FOUND);
            }
            if (!Boolean.TRUE.equals(book.getIsActive()) || !Boolean.TRUE.equals(book.getCategoryActive())) {
                throw new BusinessException("BOOK_INACTIVE", "Book is inactive.", HttpStatus.CONFLICT);
            }
        } catch (FeignException.NotFound exception) {
            throw new BusinessException("BOOK_NOT_FOUND", "Book not found.", HttpStatus.NOT_FOUND);
        } catch (FeignException exception) {
            throw downstreamUnavailable();
        }
    }

    private void decreaseStock(String sagaId, BorrowItemRequest item) {
        try {
            bookServiceClient.decreaseStock(
                    item.bookId(),
                    new StockUpdateRequest(sagaId, item.bookId(), item.quantity())
            );
        } catch (FeignException.Conflict exception) {
            throw new BusinessException(
                    "BOOK_OUT_OF_STOCK",
                    "Book is out of stock or inactive.",
                    HttpStatus.CONFLICT
            );
        } catch (FeignException.NotFound exception) {
            throw new BusinessException("BOOK_NOT_FOUND", "Book not found.", HttpStatus.NOT_FOUND);
        } catch (FeignException exception) {
            throw downstreamUnavailable();
        }
    }

    private void createFineBestEffort(SagaLog sagaLog, Borrow borrow, LocalDateTime returnDate, String createdFrom) {
        try {
            long daysOverdue = Math.max(0, ChronoUnit.DAYS.between(borrow.getDueDate().toLocalDate(), returnDate.toLocalDate()));
            fineServiceClient.createFine(new FineCreateRequest(
                    borrow.getId(),
                    borrow.getUserId(),
                    borrow.getDueDate(),
                    returnDate,
                    daysOverdue,
                    createdFrom
            ));
        } catch (Exception exception) {
            log.warn("Fine Service best-effort call failed for borrowId={}", borrow.getId(), exception);
            appendSagaError(sagaLog, SagaErrorMessage.rootCause("Fine Service failed", exception));
        }
    }

    private void sendNotificationBestEffort(SagaLog sagaLog, NotificationCreateRequest request) {
        try {
            notificationServiceClient.createNotification(request);
        } catch (Exception exception) {
            log.warn("Notification Service best-effort call failed for eventKey={}", request.eventKey(), exception);
            appendSagaError(sagaLog, SagaErrorMessage.rootCause("Notification Service failed", exception));
        }
    }

    private void markFailed(SagaLog sagaLog, String errorMessage) {
        sagaLog.setStatus(SagaStatus.FAILED);
        sagaLog.setErrorMessage(SagaErrorMessage.append(null, errorMessage));
        sagaLogRepository.save(sagaLog);
    }

    private void appendSagaError(SagaLog sagaLog, String error) {
        sagaLog.setErrorMessage(SagaErrorMessage.append(sagaLog.getErrorMessage(), error));
        sagaLogRepository.save(sagaLog);
    }

    private BusinessException downstreamUnavailable() {
        return new BusinessException(
                "SERVICE_UNAVAILABLE",
                "A downstream service is unavailable.",
                HttpStatus.SERVICE_UNAVAILABLE
        );
    }
}
