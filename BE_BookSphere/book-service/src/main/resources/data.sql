INSERT INTO categories (id, name, description, is_active, created_at, updated_at) VALUES
  (1, 'Programming', 'Sách lập trình và công nghệ phần mềm', TRUE, NOW(), NOW()),
  (2, 'Database', 'Sách về cơ sở dữ liệu', TRUE, NOW(), NOW()),
  (3, 'Software Architecture', 'Sách kiến trúc phần mềm', TRUE, NOW(), NOW()),
  (4, 'Artificial Intelligence', 'Sách về AI và Machine Learning', TRUE, NOW(), NOW()),
  (5, 'Business', 'Sách kinh doanh và quản trị', TRUE, NOW(), NOW())
ON DUPLICATE KEY UPDATE id = id;

INSERT INTO books (id, title, author, isbn, publisher, published_year, category_id, total_quantity, available_quantity, description, is_active, created_at, updated_at) VALUES
  (1, 'Clean Code', 'Robert C. Martin', '9780132350884', NULL, NULL, 1, 10, 10, NULL, TRUE, NOW(), NOW()),
  (2, 'Effective Java', 'Joshua Bloch', '9780134685991', NULL, NULL, 1, 8, 8, NULL, TRUE, NOW(), NOW()),
  (3, 'Spring Microservices in Action', 'John Carnell', '9781617293986', NULL, NULL, 3, 6, 6, NULL, TRUE, NOW(), NOW()),
  (4, 'Designing Data-Intensive Applications', 'Martin Kleppmann', '9781449373320', NULL, NULL, 3, 5, 5, NULL, TRUE, NOW(), NOW()),
  (5, 'Database System Concepts', 'Abraham Silberschatz', '9780073523323', NULL, NULL, 2, 7, 7, NULL, TRUE, NOW(), NOW()),
  (6, 'SQL Performance Explained', 'Markus Winand', '9783950307825', NULL, NULL, 2, 4, 4, NULL, TRUE, NOW(), NOW()),
  (7, 'Artificial Intelligence: A Modern Approach', 'Stuart Russell', '9780134610993', NULL, NULL, 4, 5, 5, NULL, TRUE, NOW(), NOW()),
  (8, 'Hands-On Machine Learning', 'Aurélien Géron', '9781492032649', NULL, NULL, 4, 6, 6, NULL, TRUE, NOW(), NOW()),
  (9, 'The Lean Startup', 'Eric Ries', '9780307887894', NULL, NULL, 5, 5, 5, NULL, TRUE, NOW(), NOW()),
  (10, 'Good to Great', 'Jim Collins', '9780066620992', NULL, NULL, 5, 5, 5, NULL, TRUE, NOW(), NOW())
ON DUPLICATE KEY UPDATE id = id;
