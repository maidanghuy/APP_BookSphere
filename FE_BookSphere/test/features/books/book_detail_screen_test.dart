import 'dart:async';

import 'package:booksphere_app/features/books/data/book_repository.dart';
import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:booksphere_app/features/books/presentation/book_detail_screen.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_detail_skeleton.dart';
import 'package:booksphere_app/features/books/providers/book_detail_provider.dart';
import 'package:booksphere_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _localizationApp(Widget home) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}

Widget _app({
  required String bookId,
  required Future<BookDetail> Function(Ref ref, String bookId) loader,
}) {
  return ProviderScope(
    overrides: [bookDetailProvider.overrideWith(loader)],
    child: _localizationApp(BookDetailScreen(bookId: bookId)),
  );
}

void main() {
  testWidgets('shows skeleton while loading', (tester) async {
    await tester.pumpWidget(
      _app(
        bookId: '1',
        loader: (ref, id) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return const BookDetail(id: '1', title: 'Clean Code');
        },
      ),
    );
    expect(find.byType(BookDetailSkeleton), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('shows title author category and availability', (tester) async {
    await tester.pumpWidget(
      _app(
        bookId: '1',
        loader: (ref, id) async => const BookDetail(
          id: '1',
          title: 'Clean Code',
          author: 'Robert C. Martin',
          categoryName: 'Software',
          availableQuantity: 3,
          totalQuantity: 5,
          description: 'A handbook.',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Clean Code'), findsOneWidget);
    expect(find.text('Robert C. Martin'), findsOneWidget);
    expect(find.text('Software'), findsWidgets);
    expect(find.textContaining('3 / 5'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('A handbook.'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('A handbook.'), findsOneWidget);
  });

  testWidgets('shows description fallback', (tester) async {
    await tester.pumpWidget(
      _app(
        bookId: '1',
        loader: (ref, id) async => const BookDetail(
          id: '1',
          title: 'No Desc',
          description: null,
          availableQuantity: 1,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('No description available.'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('No description available.'), findsOneWidget);
  });

  testWidgets('shows not found state', (tester) async {
    final completer = Completer<BookDetail>();
    await tester.pumpWidget(
      _app(bookId: '404', loader: (ref, id) => completer.future),
    );
    await tester.pump();
    expect(find.byType(BookDetailSkeleton), findsOneWidget);

    completer.completeError(
      const BookException(
        message: 'missing',
        code: 'BOOK_NOT_FOUND',
        statusCode: 404,
      ),
    );
    await tester.pump();
    tester.takeException();
    await tester.pump();

    expect(find.text('Book not found.'), findsOneWidget);
    expect(find.text('Back to books'), findsOneWidget);
  });

  testWidgets('shows error state with retry', (tester) async {
    await tester.pumpWidget(
      _localizationApp(
        BookDetailErrorBody(
          error: const BookException(
            message: 'offline',
            code: 'NETWORK_ERROR',
            statusCode: 0,
          ),
          onRetry: () async {},
          onBackToBooks: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Unable to connect'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('empty bookId shows not found', (tester) async {
    var called = false;
    await tester.pumpWidget(
      _app(
        bookId: '  ',
        loader: (ref, id) async {
          called = true;
          return const BookDetail(id: '1', title: 'Nope');
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Book not found.'), findsOneWidget);
    expect(called, isFalse);
  });
}
