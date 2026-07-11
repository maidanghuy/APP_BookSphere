import 'dart:async';

import 'package:booksphere_app/features/auth/providers/auth_guard_provider.dart';
import 'package:booksphere_app/features/books/data/book_api.dart';
import 'package:booksphere_app/features/books/data/book_repository.dart';
import 'package:booksphere_app/features/books/data/models/book_summary.dart';
import 'package:booksphere_app/features/books/data/models/category_summary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int _defaultPageSize = 10;
const Duration _searchDebounce = Duration(milliseconds: 450);

final bookApiProvider = Provider<BookApi>((ref) {
  return BookApi(ref.watch(dioClientProvider));
});

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepository(ref.watch(bookApiProvider));
});

enum BookAvailabilityFilter { all, available, unavailable }

class BookListState {
  const BookListState({
    this.books = const [],
    this.categories = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.errorCode,
    this.errorStatusCode,
    this.searchKeyword = '',
    this.selectedCategoryId,
    this.availabilityFilter = BookAvailabilityFilter.all,
    this.currentPage = 0,
    this.hasMore = true,
    this.hasActiveFilters = false,
  });

  final List<BookSummary> books;
  final List<CategorySummary> categories;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? errorMessage;
  final String? errorCode;
  final int? errorStatusCode;
  final String searchKeyword;
  final String? selectedCategoryId;
  final BookAvailabilityFilter availabilityFilter;
  final int currentPage;
  final bool hasMore;
  final bool hasActiveFilters;

  /// Books after optional client-side availability filter.
  ///
  /// Backend `/api/books` does not expose an availability query parameter.
  List<BookSummary> get visibleBooks {
    switch (availabilityFilter) {
      case BookAvailabilityFilter.all:
        return books;
      case BookAvailabilityFilter.available:
        return books.where((book) => book.isAvailable).toList();
      case BookAvailabilityFilter.unavailable:
        return books.where((book) => !book.isAvailable).toList();
    }
  }

  bool get hasError => errorMessage != null || errorCode != null;

  BookListState copyWith({
    List<BookSummary>? books,
    List<CategorySummary>? categories,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
    String? errorCode,
    int? errorStatusCode,
    String? searchKeyword,
    String? selectedCategoryId,
    BookAvailabilityFilter? availabilityFilter,
    int? currentPage,
    bool? hasMore,
    bool? hasActiveFilters,
    bool clearError = false,
    bool clearCategory = false,
  }) {
    return BookListState(
      books: books ?? this.books,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorStatusCode: clearError
          ? null
          : errorStatusCode ?? this.errorStatusCode,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      selectedCategoryId: clearCategory
          ? null
          : selectedCategoryId ?? this.selectedCategoryId,
      availabilityFilter: availabilityFilter ?? this.availabilityFilter,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      hasActiveFilters: hasActiveFilters ?? this.hasActiveFilters,
    );
  }
}

class BookListNotifier extends Notifier<BookListState> {
  Timer? _searchDebounceTimer;
  bool _isFetchInFlight = false;

  @override
  BookListState build() {
    ref.onDispose(() {
      _searchDebounceTimer?.cancel();
    });
    Future.microtask(loadInitial);
    return const BookListState(isLoading: true);
  }

  BookRepository get _repository => ref.read(bookRepositoryProvider);

  Future<void> loadInitial() async {
    await _loadPage(page: 0, replace: true, showFullLoading: true);
  }

  Future<void> refresh() async {
    if (_isFetchInFlight) {
      return;
    }
    await _loadPage(page: 0, replace: true, isRefreshing: true);
  }

  Future<void> retry() => loadInitial();

  Future<void> loadMore() async {
    if (_isFetchInFlight ||
        state.isLoading ||
        state.isLoadingMore ||
        state.isRefreshing ||
        !state.hasMore) {
      return;
    }
    await _loadPage(
      page: state.currentPage + 1,
      replace: false,
      isLoadingMore: true,
    );
  }

  Future<void> setSearchKeyword(String keyword) async {
    final trimmed = keyword.trim();
    if (trimmed == state.searchKeyword) {
      return;
    }

    state = state.copyWith(
      searchKeyword: trimmed,
      hasActiveFilters: _computeHasActiveFilters(
        keyword: trimmed,
        categoryId: state.selectedCategoryId,
        availability: state.availabilityFilter,
      ),
    );

    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(_searchDebounce, () {
      unawaited(_loadPage(page: 0, replace: true, showFullLoading: true));
    });
  }

  Future<void> setCategory(String? categoryId) async {
    final normalized = categoryId?.trim();
    final nextCategoryId = (normalized == null || normalized.isEmpty)
        ? null
        : normalized;

    if (nextCategoryId == state.selectedCategoryId) {
      return;
    }

    state = state.copyWith(
      selectedCategoryId: nextCategoryId,
      clearCategory: nextCategoryId == null,
      hasActiveFilters: _computeHasActiveFilters(
        keyword: state.searchKeyword,
        categoryId: nextCategoryId,
        availability: state.availabilityFilter,
      ),
    );

    await _loadPage(page: 0, replace: true, showFullLoading: true);
  }

  Future<void> setAvailabilityFilter(BookAvailabilityFilter filter) async {
    if (filter == state.availabilityFilter) {
      return;
    }

    state = state.copyWith(
      availabilityFilter: filter,
      hasActiveFilters: _computeHasActiveFilters(
        keyword: state.searchKeyword,
        categoryId: state.selectedCategoryId,
        availability: filter,
      ),
    );
  }

  Future<void> setAvailableOnly(bool? value) async {
    final filter = switch (value) {
      true => BookAvailabilityFilter.available,
      false => BookAvailabilityFilter.unavailable,
      null => BookAvailabilityFilter.all,
    };
    await setAvailabilityFilter(filter);
  }

  Future<void> clearFilters() async {
    _searchDebounceTimer?.cancel();
    state = state.copyWith(
      searchKeyword: '',
      clearCategory: true,
      availabilityFilter: BookAvailabilityFilter.all,
      hasActiveFilters: false,
    );
    await _loadPage(page: 0, replace: true, showFullLoading: true);
  }

  Future<void> _loadPage({
    required int page,
    required bool replace,
    bool showFullLoading = false,
    bool isRefreshing = false,
    bool isLoadingMore = false,
  }) async {
    if (_isFetchInFlight) {
      return;
    }

    _isFetchInFlight = true;
    state = state.copyWith(
      isLoading: showFullLoading,
      isRefreshing: isRefreshing,
      isLoadingMore: isLoadingMore,
      clearError: true,
    );

    try {
      final bookPage = await _repository.getBooks(
        page: page,
        size: _defaultPageSize,
        keyword: state.searchKeyword,
        categoryId: state.selectedCategoryId,
      );

      List<CategorySummary> categories = state.categories;
      if (replace || categories.isEmpty) {
        try {
          categories = await _repository.getCategories();
        } on BookException {
          // Category filter is optional; keep existing list on failure.
        }
      }

      final mergedBooks = replace
          ? bookPage.items
          : _mergeWithoutDuplicates(state.books, bookPage.items);

      state = state.copyWith(
        books: mergedBooks,
        categories: categories,
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        currentPage: bookPage.page,
        hasMore: bookPage.hasMore,
        clearError: true,
      );
    } on BookException catch (error) {
      // Keep the existing list visible when load-more fails.
      if (isLoadingMore) {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          isLoadingMore: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          isLoadingMore: false,
          books: replace ? const [] : state.books,
          errorMessage: error.message,
          errorCode: error.code,
          errorStatusCode: error.statusCode,
        );
      }
    } catch (_) {
      if (isLoadingMore) {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          isLoadingMore: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          isLoadingMore: false,
          books: replace ? const [] : state.books,
          errorCode: 'UNKNOWN_ERROR',
          errorMessage: 'Unable to load books.',
        );
      }
    } finally {
      _isFetchInFlight = false;
    }
  }

  List<BookSummary> _mergeWithoutDuplicates(
    List<BookSummary> existing,
    List<BookSummary> incoming,
  ) {
    final seenIds = existing.map((book) => book.id).toSet();
    final merged = List<BookSummary>.from(existing);
    for (final book in incoming) {
      if (seenIds.add(book.id)) {
        merged.add(book);
      }
    }
    return merged;
  }

  bool _computeHasActiveFilters({
    required String keyword,
    required String? categoryId,
    required BookAvailabilityFilter availability,
  }) {
    return keyword.isNotEmpty ||
        (categoryId != null && categoryId.isNotEmpty) ||
        availability != BookAvailabilityFilter.all;
  }
}

final bookListProvider = NotifierProvider<BookListNotifier, BookListState>(
  BookListNotifier.new,
);
