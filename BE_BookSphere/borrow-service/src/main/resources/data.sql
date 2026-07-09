INSERT INTO borrows (id, user_id, borrow_date, due_date, return_date, status, created_at, updated_at) VALUES
  (1, 3, '2026-07-01 09:00:00', '2026-07-08 23:59:59', NULL, 'BORROWING', NOW(), NOW()),
  (2, 4, '2026-06-20 10:00:00', '2026-06-27 23:59:59', '2026-06-30 14:00:00', 'RETURNED', NOW(), NOW())
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO borrow_items (id, borrow_id, book_id, quantity, status) VALUES
  (1, 1, 1, 1, 'BORROWED'),
  (2, 1, 3, 1, 'BORROWED'),
  (3, 2, 5, 1, 'RETURNED')
ON DUPLICATE KEY UPDATE id = id;
