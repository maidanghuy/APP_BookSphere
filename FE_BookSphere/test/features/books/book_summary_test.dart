import 'package:booksphere_app/features/books/data/models/book_page.dart';
import 'package:booksphere_app/features/books/data/models/book_summary.dart';
import 'package:booksphere_app/features/books/data/models/category_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookSummary', () {
    test('parses backend book response fields', () {
      final book = BookSummary.fromJson({
        'id': 1,
        'title': 'Clean Code',
        'author': 'Robert C. Martin',
        'isbn': '9780132350884',
        'categoryId': 2,
        'categoryName': 'Software Engineering',
        'totalQuantity': 10,
        'availableQuantity': 3,
        'isActive': true,
      });

      expect(book.id, '1');
      expect(book.title, 'Clean Code');
      expect(book.author, 'Robert C. Martin');
      expect(book.categoryId, '2');
      expect(book.categoryName, 'Software Engineering');
      expect(book.totalQuantity, 10);
      expect(book.availableQuantity, 3);
      expect(book.isAvailable, isTrue);
    });

    test('handles null author, category and quantity safely', () {
      final book = BookSummary.fromJson({
        'id': '42',
        'title': 'Untitled',
        'author': null,
        'categoryId': null,
        'categoryName': null,
        'availableQuantity': null,
      });

      expect(book.id, '42');
      expect(book.author, isNull);
      expect(book.categoryId, isNull);
      expect(book.availableQuantity, isNull);
      expect(book.isAvailable, isFalse);
    });

    test('marks unavailable when availableQuantity is zero', () {
      final book = BookSummary.fromJson({
        'id': 7,
        'title': 'Out of Stock',
        'availableQuantity': 0,
      });

      expect(book.isAvailable, isFalse);
    });
  });

  group('BookPage', () {
    test('parses PageResponse contract', () {
      final page = BookPage.fromJson({
        'content': [
          {'id': 1, 'title': 'Clean Code', 'availableQuantity': 2},
        ],
        'page': 0,
        'size': 10,
        'totalElements': 1,
        'totalPages': 1,
      });

      expect(page.items, hasLength(1));
      expect(page.page, 0);
      expect(page.size, 10);
      expect(page.totalElements, 1);
      expect(page.totalPages, 1);
      expect(page.isLast, isTrue);
      expect(page.hasMore, isFalse);
    });

    test('computes hasMore from page and totalPages', () {
      final page = BookPage.fromJson({
        'content': <Object>[],
        'page': 0,
        'size': 10,
        'totalElements': 25,
        'totalPages': 3,
      });

      expect(page.isLast, isFalse);
      expect(page.hasMore, isTrue);
    });
  });

  group('CategorySummary', () {
    test('parses category response', () {
      final category = CategorySummary.fromJson({
        'id': 5,
        'name': 'Science',
        'description': 'Science books',
        'isActive': true,
      });

      expect(category.id, '5');
      expect(category.name, 'Science');
      expect(category.isActive, isTrue);
    });
  });
}
