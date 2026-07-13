import 'dart:async';

import 'package:booksphere_app/features/auth/providers/auth_guard_provider.dart';
import 'package:booksphere_app/features/books/data/book_api.dart';
import 'package:booksphere_app/features/books/data/book_repository.dart';
import 'package:booksphere_app/features/books/data/models/book_filter.dart';
import 'package:booksphere_app/features/books/data/models/book_summary.dart';
import 'package:booksphere_app/features/books/data/models/category_summary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'package:booksphere_app/features/books/data/models/book_filter.dart';

const int _defaultPageSize = 10;
const Duration _searchDebounce = Duration(milliseconds: 450);

final bookApiProvider = Provider<BookApi>((ref) {
  return BookApi(ref.watch(dioClientProvider));
});

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepository(ref.watch(bookApiProvider));
});

class BookListState {
  const BookListState({
    this.books = const [],
    this.categories = const [],
    this.filter = const BookFilter(),
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.errorCode,
    this.errorStatusCode,
    this.categoriesErrorCode,
    this.currentPage = 0,
    this.hasMore = true,
  });

  final List<BookSummary> books;
  final List<CategorySummary> categories;
  final BookFilter filter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? errorMessage;
  final String? errorCode;
  final int? errorStatusCode;
  final String? categoriesErrorCode;
  final int currentPage;
  final bool hasMore;

  String get searchKeyword => filter.keyword;
  String? get selectedCategoryId => filter.categoryId;
  BookAvailabilityFilter get availabilityFilter => filter.availability;
  bool get hasActiveFilters => filter.hasActiveFilters;

  /// Books after optional client-side availability filter.
  List<BookSummary> get visibleBooks {
    switch (filter.availability) {
      case BookAvailabilityFilter.all:
        return books;
      case BookAvailabilityFilter.available:
        return books.where((book) => book.isAvailable).toList();
      case BookAvailabilityFilter.unavailable:
        return books.where((book) => !book.isAvailable).toList();
    }
  }

  bool get hasError => errorMessage != null || errorCode != null;

  bool get hasCategoriesError => categoriesErrorCode != null;

  String? get selectedCategoryName {
    final id = filter.categoryId;
    if (id == null) {
      return null;
    }
    for (final category in categories) {
      if (category.id == id) {
        return category.name;
      }
    }
    return null;
  }

  BookListState copyWith({
    List<BookSummary>? books,
    List<CategorySummary>? categories,
    BookFilter? filter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
    String? errorCode,
    int? errorStatusCode,
    String? categoriesErrorCode,
    int? currentPage,
    bool? hasMore,
    bool clearError = false,
    bool clearCategoriesError = false,
  }) {
    return BookListState(
      books: books ?? this.books,
      categories: categories ?? this.categories,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorStatusCode: clearError
          ? null
          : errorStatusCode ?? this.errorStatusCode,
      categoriesErrorCode: clearCategoriesError
          ? null
          : categoriesErrorCode ?? this.categoriesErrorCode,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class BookListNotifier extends Notifier<BookListState> {
  Timer? _searchDebounceTimer;
  bool _isLoadMoreInFlight = false;
  int _requestSequence = 0;

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
    if (state.isLoading || state.isRefreshing || state.isLoadingMore) {
      return;
    }
    await _loadPage(page: 0, replace: true, isRefreshing: true);
  }

  Future<void> retry() => loadInitial();

  Future<void> loadMore() async {
    if (_isLoadMoreInFlight ||
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

  /// Debounced search. Does not clear category/availability filters.
  Future<void> search(String keyword) async {
    final trimmed = keyword.trim();
    if (trimmed == state.filter.keyword) {
      return;
    }

    state = state.copyWith(filter: state.filter.copyWith(keyword: trimmed));

    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(_searchDebounce, () {
      unawaited(_loadPage(page: 0, replace: true, showFullLoading: true));
    });
  }

  /// Alias used by the search field `onChanged`.
  Future<void> setSearchKeyword(String keyword) => search(keyword);

  Future<void> applyFilter(BookFilter filter) async {
    _searchDebounceTimer?.cancel();
    final normalized = BookFilter(
      keyword: filter.keyword.trim(),
      categoryId: filter.categoryId?.trim().isEmpty ?? true
          ? null
          : filter.categoryId?.trim(),
      availability: filter.availability,
    );

    if (normalized == state.filter) {
      return;
    }

    state = state.copyWith(filter: normalized);
    await _loadPage(page: 0, replace: true, showFullLoading: true);
  }

  Future<void> setCategory(String? categoryId) async {
    final next = state.filter.copyWith(
      categoryId: categoryId,
      clearCategory: categoryId == null || categoryId.trim().isEmpty,
    );
    await applyFilter(next);
  }

  Future<void> setAvailabilityFilter(
    BookAvailabilityFilter availability,
  ) async {
    if (availability == state.filter.availability) {
      return;
    }
    // Client-side only — no API round-trip required.
    state = state.copyWith(
      filter: state.filter.copyWith(availability: availability),
    );
  }

  Future<void> setAvailableOnly(bool? value) async {
    final availability = switch (value) {
      true => BookAvailabilityFilter.available,
      false => BookAvailabilityFilter.unavailable,
      null => BookAvailabilityFilter.all,
    };
    await setAvailabilityFilter(availability);
  }

  Future<void> clearSearch() async {
    _searchDebounceTimer?.cancel();
    if (!state.filter.hasKeyword) {
      return;
    }
    state = state.copyWith(filter: state.filter.copyWith(keyword: ''));
    await _loadPage(page: 0, replace: true, showFullLoading: true);
  }

  Future<void> clearCategoryFilter() async {
    if (!state.filter.hasCategory) {
      return;
    }
    await applyFilter(state.filter.copyWith(clearCategory: true));
  }

  Future<void> clearAvailabilityFilter() async {
    if (!state.filter.hasAvailability) {
      return;
    }
    await setAvailabilityFilter(BookAvailabilityFilter.all);
  }

  Future<void> resetFilters() async {
    _searchDebounceTimer?.cancel();
    if (!state.filter.hasActiveFilters) {
      return;
    }
    state = state.copyWith(filter: const BookFilter());
    await _loadPage(page: 0, replace: true, showFullLoading: true);
  }

  /// Backward-compatible alias.
  Future<void> clearFilters() => resetFilters();

  Future<void> retryLoadCategories() async {
    try {
      final categories = await _repository.getCategories();
      state = state.copyWith(
        categories: categories,
        clearCategoriesError: true,
      );
    } on BookException catch (error) {
      state = state.copyWith(
        categoriesErrorCode: error.code ?? 'UNKNOWN_ERROR',
      );
    } catch (_) {
      state = state.copyWith(categoriesErrorCode: 'UNKNOWN_ERROR');
    }
  }

  Future<void> _loadPage({
    required int page,
    required bool replace,
    bool showFullLoading = false,
    bool isRefreshing = false,
    bool isLoadingMore = false,
  }) async {
    if (isLoadingMore && _isLoadMoreInFlight) {
      return;
    }

    final sequence = ++_requestSequence;
    if (isLoadingMore) {
      _isLoadMoreInFlight = true;
    }

    state = state.copyWith(
      isLoading: showFullLoading,
      isRefreshing: isRefreshing,
      isLoadingMore: isLoadingMore,
      clearError: true,
    );

    final requestFilter = state.filter;

    try {
      final bookPage = await _repository.searchBooks(
        page: page,
        size: _defaultPageSize,
        filter: requestFilter,
      );

      if (sequence != _requestSequence) {
        return;
      }

      List<CategorySummary> categories = state.categories;
      var categoriesError = state.categoriesErrorCode;
      if (replace || categories.isEmpty) {
        try {
          categories = await _repository.getCategories();
          categoriesError = null;
        } on BookException catch (error) {
          categoriesError = error.code ?? 'UNKNOWN_ERROR';
        } catch (_) {
          categoriesError = 'UNKNOWN_ERROR';
        }
      }

      if (sequence != _requestSequence) {
        return;
      }

      final mergedBooks = replace
          ? bookPage.items
          : _mergeWithoutDuplicates(state.books, bookPage.items);

      state = state.copyWith(
        books: mergedBooks,
        categories: categories,
        categoriesErrorCode: categoriesError,
        clearCategoriesError: categoriesError == null,
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        currentPage: bookPage.page,
        hasMore: bookPage.hasMore,
        clearError: true,
      );
    } on BookException catch (error) {
      if (sequence != _requestSequence) {
        return;
      }
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
          books: isRefreshing
              ? state.books
              : replace
              ? const []
              : state.books,
          errorMessage: error.message,
          errorCode: error.code,
          errorStatusCode: error.statusCode,
        );
      }
    } catch (_) {
      if (sequence != _requestSequence) {
        return;
      }
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
          books: isRefreshing
              ? state.books
              : replace
              ? const []
              : state.books,
          errorCode: 'UNKNOWN_ERROR',
          errorMessage: 'Unable to load books.',
        );
      }
    } finally {
      if (isLoadingMore) {
        _isLoadMoreInFlight = false;
      }
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
}

final bookListProvider = NotifierProvider<BookListNotifier, BookListState>(
  BookListNotifier.new,
);
