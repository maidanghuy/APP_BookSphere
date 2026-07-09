package com.booksphere.borrow.saga;

public enum BorrowSagaStep {
    CHECK_BOOK,
    DECREASE_STOCK,
    CREATE_BORROW,
    INCREASE_STOCK,
    CREATE_FINE,
    SEND_NOTIFICATION,
    UPDATE_BORROW_RETURNED,
    MARK_OVERDUE
}
