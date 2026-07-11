import 'package:booksphere_app/features/books/data/models/book_filter.dart';
import 'package:booksphere_app/features/books/data/models/book_summary.dart';
import 'package:booksphere_app/features/books/data/models/category_summary.dart';
import 'package:booksphere_app/features/books/presentation/book_list_screen.dart';
import 'package:booksphere_app/features/books/presentation/widgets/active_filter_chips.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_filter_bottom_sheet.dart';
import 'package:booksphere_app/features/books/providers/book_list_provider.dart';
import 'package:booksphere_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FixedBookListNotifier extends BookListNotifier {
  _FixedBookListNotifier(this._fixedState);

  BookListState _fixedState;

  @override
  BookListState build() => _fixedState;

  @override
  Future<void> loadInitial() async {}

  @override
  Future<void> refresh() async {}

  @override
  Future<void> retry() async {}

  @override
  Future<void> loadMore() async {}

  @override
  Future<void> search(String keyword) async {}

  @override
  Future<void> setSearchKeyword(String keyword) async {}

  @override
  Future<void> applyFilter(BookFilter filter) async {
    _fixedState = _fixedState.copyWith(filter: filter);
    state = _fixedState;
  }

  @override
  Future<void> setCategory(String? categoryId) async {}

  @override
  Future<void> setAvailabilityFilter(BookAvailabilityFilter filter) async {}

  @override
  Future<void> clearSearch() async {}

  @override
  Future<void> clearCategoryFilter() async {}

  @override
  Future<void> clearAvailabilityFilter() async {}

  @override
  Future<void> resetFilters() async {}

  @override
  Future<void> clearFilters() async {}

  @override
  Future<void> retryLoadCategories() async {}
}

Widget _wrap(Widget child, {required BookListState state}) {
  return ProviderScope(
    overrides: [
      bookListProvider.overrideWith(() => _FixedBookListNotifier(state)),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

void main() {
  testWidgets('shows search field and filter button', (tester) async {
    await tester.pumpWidget(
      _wrap(const BookListScreen(), state: const BookListState()),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.tune), findsOneWidget);
  });

  testWidgets('shows skeleton while loading', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const BookListScreen(),
        state: const BookListState(isLoading: true),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsWidgets);
  });

  testWidgets('shows empty state', (tester) async {
    await tester.pumpWidget(
      _wrap(const BookListScreen(), state: const BookListState(books: [])),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('No books'), findsOneWidget);
  });

  testWidgets('shows empty search state', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const BookListScreen(),
        state: const BookListState(
          books: [],
          filter: BookFilter(keyword: 'zzz'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No books match your search.'), findsOneWidget);
  });

  testWidgets('shows error state with retry', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const BookListScreen(),
        state: const BookListState(
          errorCode: 'NETWORK_ERROR',
          errorMessage: 'failed',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Unable to connect'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('shows book card when data exists', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const BookListScreen(),
        state: const BookListState(
          books: [
            BookSummary(
              id: '1',
              title: 'Clean Code',
              author: 'Robert C. Martin',
              categoryName: 'Software',
              availableQuantity: 3,
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Clean Code'), findsOneWidget);
    expect(find.text('Robert C. Martin'), findsOneWidget);
    expect(find.textContaining('copies available'), findsOneWidget);
  });

  testWidgets('shows active filter chips', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const BookListScreen(),
        state: const BookListState(
          books: [
            BookSummary(id: '1', title: 'Clean Code', availableQuantity: 1),
          ],
          categories: [CategorySummary(id: '1', name: 'Software')],
          filter: BookFilter(
            categoryId: '1',
            availability: BookAvailabilityFilter.available,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ActiveFilterChips), findsOneWidget);
    expect(find.textContaining('Software'), findsOneWidget);
    expect(find.text('Available'), findsWidgets);
    expect(find.text('Clear all'), findsOneWidget);
  });

  testWidgets('opens filter bottom sheet and cancels without apply', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const BookListScreen(),
        state: const BookListState(
          categories: [CategorySummary(id: '1', name: 'Software')],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();

    expect(find.byType(BookFilterBottomSheet), findsOneWidget);
    expect(find.text('Filters'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(BookFilterBottomSheet), findsNothing);
  });

  testWidgets('filter bottom sheet apply returns draft filter', (tester) async {
    BookFilter? applied;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  applied = await showBookFilterBottomSheet(
                    context: context,
                    initialFilter: const BookFilter(),
                    categories: const [
                      CategorySummary(id: '1', name: 'Software'),
                    ],
                  );
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Available'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    expect(applied?.availability, BookAvailabilityFilter.available);
  });
}
