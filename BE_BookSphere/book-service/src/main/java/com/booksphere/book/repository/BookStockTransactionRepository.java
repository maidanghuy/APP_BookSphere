package com.booksphere.book.repository;

import com.booksphere.book.entity.BookStockTransaction;
import com.booksphere.book.entity.enums.StockAction;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookStockTransactionRepository extends JpaRepository<BookStockTransaction, Long> {

    Optional<BookStockTransaction> findBySagaIdAndBookIdAndAction(String sagaId, Long bookId, StockAction action);

    boolean existsBySagaIdAndBookIdAndAction(String sagaId, Long bookId, StockAction action);
}
