INSERT INTO roles (id, name, description) VALUES
  (1, 'ADMIN', 'Quản trị toàn bộ hệ thống'),
  (2, 'LIBRARIAN', 'Nhân viên thư viện'),
  (3, 'MEMBER', 'Người dùng mượn sách')
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO users (id, full_name, username, email, password, phone, is_active, created_at, updated_at) VALUES
  (1, 'System Admin', 'adminsys', 'admin@booksphere.com', '$2a$10$Gc/Ozglky3UdUukbxVBRTO86gxVFKSDKEbRrv.9OH6maADeJjTTzS', NULL, TRUE, NOW(), NOW()),
  (2, 'Librarian One', 'librarian01', 'librarian01@booksphere.com', '$2a$10$Gc/Ozglky3UdUukbxVBRTO86gxVFKSDKEbRrv.9OH6maADeJjTTzS', NULL, TRUE, NOW(), NOW()),
  (3, 'Mai Đăng Huy', 'huy.member', 'huy@booksphere.com', '$2a$10$Gc/Ozglky3UdUukbxVBRTO86gxVFKSDKEbRrv.9OH6maADeJjTTzS', NULL, TRUE, NOW(), NOW()),
  (4, 'Hoàng Minh Hiển', 'hien.member', 'hien@booksphere.com', '$2a$10$Gc/Ozglky3UdUukbxVBRTO86gxVFKSDKEbRrv.9OH6maADeJjTTzS', NULL, TRUE, NOW(), NOW()),
  (5, 'Disabled Member', 'disabled.member', 'disabled@booksphere.com', '$2a$10$Gc/Ozglky3UdUukbxVBRTO86gxVFKSDKEbRrv.9OH6maADeJjTTzS', NULL, FALSE, NOW(), NOW())
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO user_roles (user_id, role_id) VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 3),
  (5, 3)
ON DUPLICATE KEY UPDATE user_id = user_id;
