package com.booksphere.borrow.repository;

import com.booksphere.borrow.entity.BorrowItem;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BorrowItemRepository extends JpaRepository<BorrowItem, Long> {

    List<BorrowItem> findByBorrow_Id(Long borrowId);

    List<BorrowItem> findByBorrow_IdIn(List<Long> borrowIds);
}
