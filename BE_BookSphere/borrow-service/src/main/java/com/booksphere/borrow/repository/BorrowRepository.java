package com.booksphere.borrow.repository;

import com.booksphere.borrow.entity.Borrow;
import com.booksphere.borrow.entity.enums.BorrowStatus;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface BorrowRepository extends JpaRepository<Borrow, Long>, JpaSpecificationExecutor<Borrow> {

    Optional<Borrow> findByIdAndUserId(Long id, Long userId);

    List<Borrow> findByStatusAndDueDateBefore(BorrowStatus status, LocalDateTime dueDate);

    List<Borrow> findByStatusAndDueDateBetween(BorrowStatus status, LocalDateTime fromDate, LocalDateTime toDate);
}
