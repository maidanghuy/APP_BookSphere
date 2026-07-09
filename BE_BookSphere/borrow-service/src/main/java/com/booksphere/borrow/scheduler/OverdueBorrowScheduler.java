package com.booksphere.borrow.scheduler;

import com.booksphere.borrow.config.BorrowSchedulerProperties;
import com.booksphere.borrow.entity.Borrow;
import com.booksphere.borrow.entity.enums.BorrowStatus;
import com.booksphere.borrow.repository.BorrowRepository;
import com.booksphere.borrow.saga.BorrowSagaOrchestrator;
import java.time.LocalDateTime;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class OverdueBorrowScheduler {

    private static final Logger log = LoggerFactory.getLogger(OverdueBorrowScheduler.class);

    private final BorrowRepository borrowRepository;
    private final BorrowSagaOrchestrator borrowSagaOrchestrator;
    private final BorrowSchedulerProperties schedulerProperties;

    public OverdueBorrowScheduler(
            BorrowRepository borrowRepository,
            BorrowSagaOrchestrator borrowSagaOrchestrator,
            BorrowSchedulerProperties schedulerProperties
    ) {
        this.borrowRepository = borrowRepository;
        this.borrowSagaOrchestrator = borrowSagaOrchestrator;
        this.schedulerProperties = schedulerProperties;
    }

    @Scheduled(fixedDelayString = "${booksphere.borrow.overdue-scheduler.fixed-delay-ms:60000}")
    public void markOverdueBorrows() {
        if (!schedulerProperties.getOverdueScheduler().isEnabled()) {
            return;
        }

        List<Borrow> overdueBorrows = borrowRepository.findByStatusAndDueDateBefore(
                BorrowStatus.BORROWING,
                LocalDateTime.now()
        );
        for (Borrow borrow : overdueBorrows) {
            try {
                borrowSagaOrchestrator.markBorrowOverdue(borrow);
            } catch (Exception exception) {
                log.warn("Failed to process overdue borrowId={}", borrow.getId(), exception);
            }
        }
    }

    @Scheduled(fixedDelayString = "${booksphere.borrow.due-soon.fixed-delay-ms:300000}")
    public void notifyDueSoonBorrows() {
        if (!schedulerProperties.getDueSoon().isEnabled()) {
            return;
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime until = now.plusHours(schedulerProperties.getDueSoon().getWindowHours());
        List<Borrow> dueSoonBorrows = borrowRepository.findByStatusAndDueDateBetween(
                BorrowStatus.BORROWING,
                now,
                until
        );
        for (Borrow borrow : dueSoonBorrows) {
            try {
                borrowSagaOrchestrator.sendDueSoonNotification(borrow);
            } catch (Exception exception) {
                log.warn("Failed to notify due-soon borrowId={}", borrow.getId(), exception);
            }
        }
    }
}
