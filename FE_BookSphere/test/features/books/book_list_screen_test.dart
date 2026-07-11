import 'package:booksphere_app/features/books/data/models/book_summary.dart';
import 'package:booksphere_app/features/books/presentation/book_list_screen.dart';
import 'package:booksphere_app/features/books/providers/book_list_provider.dart';
import 'package:booksphere_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FixedBookListNotifier extends BookListNotifier {
  _FixedBookListNotifier(this._fixedState);

  final BookListState _fixedState;

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
  Future<void> setSearchKeyword(String keyword) async {}

  @override
  Future<void> setCategory(String? categoryId) async {}

  @override
  Future<void> setAvailabilityFilter(BookAvailabilityFilter filter) async {}

  @override
  Future<void> clearFilters() async {}
}

Widget _wrap(Widget child, {required BookListState state}) {
  return ProviderScope(
    overrides: [
      bookListProvider.overrideWith(() => _FixedBookListNotifier(state)),
    ],
    child: MaterialApp(
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
}
