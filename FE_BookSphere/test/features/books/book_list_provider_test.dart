import 'package:booksphere_app/features/books/data/book_repository.dart';
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

  test('loads initial books successfully', () async {
    when(
      () => repository.getBooks(
        page: any(named: 'page'),
        size: any(named: 'size'),
        keyword: any(named: 'keyword'),
        categoryId: any(named: 'categoryId'),
      ),
    ).thenAnswer(
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
    expect(state.books, hasLength(1));
    expect(state.books.first.title, 'Clean Code');
    expect(state.categories, hasLength(1));
    expect(state.hasMore, isFalse);
  });

  test('handles empty list', () async {
    when(
      () => repository.getBooks(
        page: any(named: 'page'),
        size: any(named: 'size'),
        keyword: any(named: 'keyword'),
        categoryId: any(named: 'categoryId'),
      ),
    ).thenAnswer(
      (_) async => _page(items: const [], totalElements: 0, totalPages: 0),
    );

    final container = createContainer();
    container.read(bookListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(bookListProvider);
    expect(state.books, isEmpty);
    expect(state.hasError, isFalse);
  });

  test('handles load error', () async {
    when(
      () => repository.getBooks(
        page: any(named: 'page'),
        size: any(named: 'size'),
        keyword: any(named: 'keyword'),
        categoryId: any(named: 'categoryId'),
      ),
    ).thenThrow(const BookException(message: 'failed', code: 'NETWORK_ERROR'));

    final container = createContainer();
    container.read(bookListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(bookListProvider);
    expect(state.hasError, isTrue);
    expect(state.errorCode, 'NETWORK_ERROR');
    expect(state.books, isEmpty);
  });

  test('append load more without duplicates', () async {
    when(
      () => repository.getBooks(
        page: 0,
        size: any(named: 'size'),
        keyword: any(named: 'keyword'),
        categoryId: any(named: 'categoryId'),
      ),
    ).thenAnswer(
      (_) async => _page(
        items: [
          _book(id: '1'),
          _book(id: '2'),
        ],
        page: 0,
        totalPages: 2,
        totalElements: 3,
      ),
    );
    when(
      () => repository.getBooks(
        page: 1,
        size: any(named: 'size'),
        keyword: any(named: 'keyword'),
        categoryId: any(named: 'categoryId'),
      ),
    ).thenAnswer(
      (_) async => _page(
        items: [
          _book(id: '2'),
          _book(id: '3'),
        ],
        page: 1,
        totalPages: 2,
        totalElements: 3,
      ),
    );

    final container = createContainer();
    final notifier = container.read(bookListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.loadMore();

    final state = container.read(bookListProvider);
    expect(state.books.map((book) => book.id), ['1', '2', '3']);
    expect(state.hasMore, isFalse);
  });

  test('resets pagination when search keyword changes', () async {
    when(
      () => repository.getBooks(
        page: any(named: 'page'),
        size: any(named: 'size'),
        keyword: any(named: 'keyword'),
        categoryId: any(named: 'categoryId'),
      ),
    ).thenAnswer(
      (_) async =>
          _page(items: [_book(id: '1')], totalPages: 2, totalElements: 11),
    );

    final container = createContainer();
    final notifier = container.read(bookListProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    await notifier.setSearchKeyword('clean');
    await Future<void>.delayed(const Duration(milliseconds: 500));

    verify(
      () => repository.getBooks(
        page: 0,
        size: any(named: 'size'),
        keyword: 'clean',
        categoryId: any(named: 'categoryId'),
      ),
    ).called(greaterThanOrEqualTo(1));

    final state = container.read(bookListProvider);
    expect(state.searchKeyword, 'clean');
    expect(state.currentPage, 0);
    expect(state.hasActiveFilters, isTrue);
  });

  test('availability filter is client-side', () async {
    when(
      () => repository.getBooks(
        page: any(named: 'page'),
        size: any(named: 'size'),
        keyword: any(named: 'keyword'),
        categoryId: any(named: 'categoryId'),
      ),
    ).thenAnswer(
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
    expect(
      container.read(bookListProvider).visibleBooks.map((book) => book.id),
      ['1'],
    );

    await notifier.setAvailableOnly(false);
    expect(
      container.read(bookListProvider).visibleBooks.map((book) => book.id),
      ['2'],
    );
  });
}
