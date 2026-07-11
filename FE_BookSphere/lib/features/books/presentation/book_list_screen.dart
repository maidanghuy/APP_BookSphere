import 'package:booksphere_app/core/constants/app_message_keys.dart';
import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/utils/error_message_mapper.dart';
import 'package:booksphere_app/features/books/data/models/book_summary.dart';
import 'package:booksphere_app/features/books/presentation/widgets/active_filter_chips.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_card.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_empty_state.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_filter_bottom_sheet.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_list_skeleton.dart';
import 'package:booksphere_app/features/books/providers/book_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookListScreen extends ConsumerStatefulWidget {
  const BookListScreen({super.key});

  @override
  ConsumerState<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends ConsumerState<BookListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(bookListProvider.notifier).loadMore();
    }
  }

  String _friendlyError(BuildContext context, BookListState state) {
    final l10n = context.l10n;
    if (state.errorStatusCode == 403 || state.errorCode == 'FORBIDDEN') {
      return l10n.accessDenied;
    }
    if (state.errorCode == AppMessageKeys.networkError) {
      return ErrorMessageMapper.mapCode(context, AppMessageKeys.networkError);
    }
    if (state.errorCode == AppMessageKeys.serverUnavailable) {
      return ErrorMessageMapper.mapCode(
        context,
        AppMessageKeys.serverUnavailable,
      );
    }
    if (state.filter.hasActiveFilters) {
      return l10n.searchBooksFailed;
    }
    return l10n.loadBooksFailed;
  }

  Future<void> _openFilters() async {
    final notifier = ref.read(bookListProvider.notifier);
    final state = ref.read(bookListProvider);
    final l10n = context.l10n;

    final result = await showBookFilterBottomSheet(
      context: context,
      initialFilter: state.filter,
      categories: state.categories,
      categoriesErrorMessage: state.hasCategoriesError
          ? l10n.loadCategoriesFailed
          : null,
      onRetryCategories: () {
        notifier.retryLoadCategories();
      },
    );

    if (result != null && mounted) {
      await notifier.applyFilter(result);
      if (_searchController.text != result.keyword) {
        _searchController.text = result.keyword;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(bookListProvider);
    final notifier = ref.read(bookListProvider.notifier);
    final visibleBooks = state.visibleBooks;

    if (state.searchKeyword.isEmpty && _searchController.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted &&
            ref.read(bookListProvider).searchKeyword.isEmpty &&
            _searchController.text.isNotEmpty) {
          _searchController.clear();
        }
      });
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.books),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onChanged: notifier.search,
                    onSubmitted: (value) {
                      notifier.search(value);
                    },
                    decoration: InputDecoration(
                      hintText: l10n.searchByTitleAuthorIsbn,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: state.searchKeyword.isEmpty
                          ? null
                          : IconButton(
                              tooltip: l10n.clearSearch,
                              onPressed: () {
                                _searchController.clear();
                                notifier.clearSearch();
                              },
                              icon: const Icon(Icons.clear),
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: l10n.filters,
                  onPressed: _openFilters,
                  icon: Badge(
                    isLabelVisible: state.filter.hasNonKeywordFilters,
                    child: const Icon(Icons.tune),
                  ),
                ),
              ],
            ),
          ),
          if (state.filter.hasCategory || state.filter.hasAvailability)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: ActiveFilterChips(
                filter: state.filter,
                categoryName: state.selectedCategoryName,
                onClearCategory: notifier.clearCategoryFilter,
                onClearAvailability: notifier.clearAvailabilityFilter,
                onResetAll: () {
                  _searchController.clear();
                  notifier.resetFilters();
                },
              ),
            ),
          Expanded(child: _buildBody(context, state, visibleBooks, notifier)),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    BookListState state,
    List<BookSummary> visibleBooks,
    BookListNotifier notifier,
  ) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    if (state.isLoading && state.books.isEmpty) {
      return const BookListSkeleton();
    }

    if (state.hasError && state.books.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(
                _friendlyError(context, state),
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.checkConnectionAndRetry,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: notifier.retry,
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: visibleBooks.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: BookEmptyState(
                    hasActiveFilters: state.hasActiveFilters,
                    filter: state.filter,
                    onClearFilters: () {
                      _searchController.clear();
                      notifier.resetFilters();
                    },
                  ),
                ),
              ],
            )
          : ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: visibleBooks.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= visibleBooks.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.loadingMore,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }

                final book = visibleBooks[index];
                return BookCard(
                  book: book,
                  onTap: () => context.push('/books/${book.id}'),
                );
              },
            ),
    );
  }
}
