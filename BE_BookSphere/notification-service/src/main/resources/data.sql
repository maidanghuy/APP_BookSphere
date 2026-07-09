INSERT INTO notifications (id, user_id, title, content, type, reference_id, event_key, is_read, created_at) VALUES
  (1, 3, 'Mượn sách thành công', 'Phiếu mượn của bạn đã được tạo thành công.', 'BORROW', 1, 'BORROW_CREATED_1', FALSE, NOW()),
  (2, 4, 'Bạn có khoản phạt chưa thanh toán', 'Bạn có khoản phạt do trả sách trễ.', 'FINE', 1, 'FINE_CREATED_1', FALSE, NOW()),
  (3, 3, 'Sách sắp đến hạn trả', 'Vui lòng trả sách trước ngày đến hạn.', 'DUE_SOON', 1, 'BORROW_DUE_SOON_1', FALSE, NOW())
ON DUPLICATE KEY UPDATE id = id;
