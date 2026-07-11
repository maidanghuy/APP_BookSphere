import 'package:booksphere_app/features/books/data/models/book_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookFilter', () {
    test('default filter has no active filters', () {
      const filter = BookFilter();
      expect(filter.hasActiveFilters, isFalse);
      expect(filter.hasKeyword, isFalse);
      expect(filter.hasCategory, isFalse);
      expect(filter.hasAvailability, isFalse);
    });

    test('hasActiveFilters detects keyword category and availability', () {
      expect(const BookFilter(keyword: 'clean').hasActiveFilters, isTrue);
      expect(const BookFilter(categoryId: '1').hasActiveFilters, isTrue);
      expect(
        const BookFilter(
          availability: BookAvailabilityFilter.available,
        ).hasActiveFilters,
        isTrue,
      );
    });

    test('copyWith updates keyword without mutating original', () {
      const original = BookFilter(keyword: 'a', categoryId: '1');
      final updated = original.copyWith(keyword: 'b');

      expect(original.keyword, 'a');
      expect(updated.keyword, 'b');
      expect(updated.categoryId, '1');
    });

    test('copyWith clearCategory removes category', () {
      const original = BookFilter(keyword: 'clean', categoryId: '9');
      final cleared = original.copyWith(clearCategory: true);

      expect(cleared.categoryId, isNull);
      expect(cleared.keyword, 'clean');
    });

    test('cleared resets all fields', () {
      const original = BookFilter(
        keyword: 'clean',
        categoryId: '2',
        availability: BookAvailabilityFilter.unavailable,
      );
      expect(original.cleared(), const BookFilter());
    });

    test('equality works', () {
      expect(
        const BookFilter(keyword: 'a', categoryId: '1'),
        const BookFilter(keyword: 'a', categoryId: '1'),
      );
      expect(
        const BookFilter(keyword: 'a'),
        isNot(const BookFilter(keyword: 'b')),
      );
    });
  });
}
