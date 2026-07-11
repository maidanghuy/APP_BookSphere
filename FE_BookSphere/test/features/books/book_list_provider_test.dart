import 'dart:async';

import 'package:booksphere_app/features/books/data/book_repository.dart';
import 'package:booksphere_app/features/books/data/models/book_filter.dart';
import 'package:booksphere_app/features/books/data/models/book_page.dart';
import 'package:booksphere_app/features/books/data/models/book_summary.dart';
import 'package:booksphere_app/features/books/data/models/category_summary.dart';
import 'package:booksphere_app/features/books/providers/book_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockBookRepository extends Mock implements BookRepository {}

BookSummary _book({
  required String id,
  String title = 'Book',
  int available = 1,
}) {
  return BookSummary(id: id, title: title, availableQuantity: available);
}

BookPage _page({
  required List<BookSummary> items,
  int page = 0,
  int totalPages = 1,
  int totalElements = 1,
}) {
  return BookPage(
    items: items,
    page: page,
    size: 10,
    totalPages: totalPages,
    totalElements: totalElements,
  );
}

void main() {
  late _MockBookRepository repository;

  setUpAll(() {
    registerFallbackValue(const BookFilter());
  });

  setUp(() {
    repository = _MockBookRepository();
    when(() => repository.getCategories()).thenAnswer(
      (_) async => const [CategorySummary(id: '1', name: 'Programming')],
    );
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [bookRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  void stubSearch(Future<BookPage> Function(Invocation) answer) {
    when(
      () => repository.searchBooks(
        page: any(named: 'page'),
        size: any(named: 'size'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer(answer);
  }

  test('loads initial books successfully', () async {
    stubSearch(
      (_) async => _page(
        items: [_book(id: '1', title: 'Clean Code')],
      ),
    );

    final container = createContainer();
    container.read(bookListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(bookListProvider);
    expect(state.isLoading, isFalse);
    expect(state.books.first.title, 'Clean Code');
    expect(state.categories, hasLength(1));
  });

  test('handles empty list', () async {
    stubSearch(
      (_) async => _page(items: const [], totalElements: 0, totalPages: 0),
    );

    final container = createContainer();
    container.read(bookListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(bookListProvider).books, isEmpty);
  });

  test('handles load error', () async {
    stubSearch(
      (_) async =>
          throw const BookException(message: 'failed', code: 'NETWORK_ERROR'),
    );

    final container = createContainer();
    container.read(bookListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(bookListProvider).errorCode, 'NETWORK_ERROR');
  });

  test('append load more without duplicates', () async {
    stubSearch((invocation) async {
      final page = invocation.namedArguments[#page] as int;
      if (page == 0) {
        return _page(
          items: [
            _book(id: '1'),
            _book(id: '2'),
          ],
          page: 0,
          totalPages: 2,
          totalElements: 3,
        );
      }
      return _page(
        items: [
          _book(id: '2'),
          _book(id: '3'),
        ],
        page: 1,
        totalPages: 2,
        totalElements: 3,
      );
    });

    final container = createContainer();
    final notifier = container.read(bookListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    await notifier.loadMore();

    expect(container.read(bookListProvider).books.map((book) => book.id), [
      '1',
      '2',
      '3',
    ]);
  });

  test('search resets pagination and keeps category', () async {
    stubSearch(
      (_) async =>
          _page(items: [_book(id: '1')], totalPages: 2, totalElements: 11),
    );

    final container = createContainer();
    final notifier = container.read(bookListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.applyFilter(const BookFilter(categoryId: '1'));
    await notifier.search('clean');
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final state = container.read(bookListProvider);
    expect(state.filter.keyword, 'clean');
    expect(state.filter.categoryId, '1');
    expect(state.currentPage, 0);
  });

  test('load more preserves current filter', () async {
    stubSearch((invocation) async {
      final page = invocation.namedArguments[#page] as int;
      return _page(
        items: [_book(id: page == 0 ? '1' : '2')],
        page: page,
        totalPages: 2,
        totalElements: 11,
      );
    });

    final container = createContainer();
    final notifier = container.read(bookListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.applyFilter(
      const BookFilter(keyword: 'java', categoryId: '1'),
    );
    await notifier.loadMore();

    verify(
      () => repository.searchBooks(
        page: 1,
        size: any(named: 'size'),
        filter: const BookFilter(keyword: 'java', categoryId: '1'),
      ),
    ).called(1);
  });

  test('availability filter is client-side', () async {
    stubSearch(
      (_) async => _page(
        items: [
          _book(id: '1', available: 2),
          _book(id: '2', available: 0),
        ],
      ),
    );

    final container = createContainer();
    final notifier = container.read(bookListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.setAvailableOnly(true);
    expect(container.read(bookListProvider).visibleBooks.map((b) => b.id), [
      '1',
    ]);
  });

  test('reset filters clears all filter fields', () async {
    stubSearch((_) async => _page(items: [_book(id: '1')]));

    final container = createContainer();
    final notifier = container.read(bookListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.applyFilter(
      const BookFilter(
        keyword: 'clean',
        categoryId: '1',
        availability: BookAvailabilityFilter.available,
      ),
    );
    await notifier.resetFilters();

    expect(container.read(bookListProvider).filter, const BookFilter());
  });

  test('stale responses do not override newer results', () async {
    final slow = Completer<BookPage>();
    final fast = Completer<BookPage>();

    stubSearch((invocation) {
      final filter = invocation.namedArguments[#filter] as BookFilter;
      if (filter.keyword == 'slow') {
        return slow.future;
      }
      if (filter.keyword == 'fast') {
        return fast.future;
      }
      return Future.value(_page(items: [_book(id: 'init')]));
    });

    final container = createContainer();
    final notifier = container.read(bookListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.search('slow');
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await notifier.search('fast');
    await Future<void>.delayed(const Duration(milliseconds: 500));

    fast.complete(_page(items: [_book(id: 'fast')]));
    await Future<void>.delayed(Duration.zero);
    slow.complete(_page(items: [_book(id: 'slow')]));
    await Future<void>.delayed(Duration.zero);

    expect(container.read(bookListProvider).books.first.id, 'fast');
    expect(container.read(bookListProvider).filter.keyword, 'fast');
  });
}
