package com.booksphere.fine.repository;

import com.booksphere.fine.entity.FinePayment;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FinePaymentRepository extends JpaRepository<FinePayment, Long> {

    List<FinePayment> findByFineIdOrderByPaidAtDesc(Long fineId);
}
