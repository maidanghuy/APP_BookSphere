INSERT INTO fines (id, user_id, borrow_id, amount, created_from, reason, status, created_at, paid_at) VALUES
  (1, 4, 2, 15000.00, 'LATE_RETURN', 'Trả sách trễ 3 ngày', 'UNPAID', NOW(), NULL)
ON DUPLICATE KEY UPDATE id = id;
