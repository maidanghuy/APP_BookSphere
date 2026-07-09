package com.booksphere.borrow.repository;

import com.booksphere.borrow.entity.SagaLog;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SagaLogRepository extends JpaRepository<SagaLog, Long> {

    Optional<SagaLog> findBySagaId(String sagaId);

    boolean existsBySagaId(String sagaId);

    List<SagaLog> findByBorrowId(Long borrowId);
}
