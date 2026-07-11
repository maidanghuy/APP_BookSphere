import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookDetail', () {
    test('parses full backend BookDetailResponse', () {
      final book = BookDetail.fromJson({
        'id': 1,
        'title': 'Clean Code',
        'author': 'Robert C. Martin',
        'isbn': '9780132350884',
        'publisher': 'Prentice Hall',
        'publishedYear': 2008,
        'categoryId': 2,
        'categoryName': 'Software Engineering',
        'totalQuantity': 10,
        'availableQuantity': 3,
        'description': 'A handbook of agile software craftsmanship.',
        'isActive': true,
        'createdAt': '2026-07-04T15:30:00',
        'updatedAt': '2026-07-04T16:00:00',
      });

      expect(book.id, '1');
      expect(book.title, 'Clean Code');
      expect(book.author, 'Robert C. Martin');
      expect(book.publisher, 'Prentice Hall');
      expect(book.publishedYear, 2008);
      expect(book.categoryId, '2');
      expect(book.totalQuantity, 10);
      expect(book.availableQuantity, 3);
      expect(book.isAvailable, isTrue);
      expect(book.description, contains('handbook'));
    });

    test('handles null optional fields safely', () {
      final book = BookDetail.fromJson({
        'id': '42',
        'title': 'Untitled',
        'author': null,
        'publisher': null,
        'publishedYear': null,
        'description': null,
        'availableQuantity': null,
      });

      expect(book.id, '42');
      expect(book.author, isNull);
      expect(book.publisher, isNull);
      expect(book.description, isNull);
      expect(book.isAvailable, isFalse);
    });

    test('parses string publishedYear and quantity values', () {
      final book = BookDetail.fromJson({
        'id': 9,
        'title': 'Effective Java',
        'publishedYear': '2018',
        'availableQuantity': '0',
        'totalQuantity': '5',
      });

      expect(book.publishedYear, 2018);
      expect(book.availableQuantity, 0);
      expect(book.totalQuantity, 5);
      expect(book.isAvailable, isFalse);
    });
  });
}
