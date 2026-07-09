package com.booksphere.fine.repository;

import com.booksphere.fine.entity.Fine;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface FineRepository extends JpaRepository<Fine, Long> {

    Optional<Fine> findByBorrowId(Long borrowId);

    boolean existsByBorrowId(Long borrowId);

    @Query("""
            SELECT f FROM Fine f
            WHERE (:userId IS NULL OR f.userId = :userId)
              AND (:borrowId IS NULL OR f.borrowId = :borrowId)
              AND (:status IS NULL OR f.status = :status)
            """)
    Page<Fine> search(
            @Param("userId") Long userId,
            @Param("borrowId") Long borrowId,
            @Param("status") String status,
            Pageable pageable
    );
}
