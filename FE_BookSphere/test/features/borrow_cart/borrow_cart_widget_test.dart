import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:booksphere_app/features/books/presentation/book_detail_route_args.dart';
import 'package:booksphere_app/features/books/presentation/book_detail_screen.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_quantity_selector.dart';
import 'package:booksphere_app/features/books/providers/book_detail_provider.dart';
import 'package:booksphere_app/features/borrow_cart/data/borrow_cart_item.dart';
import 'package:booksphere_app/features/borrow_cart/presentation/borrow_cart_screen.dart';
import 'package:booksphere_app/features/borrow_cart/presentation/widgets/floating_borrow_cart.dart';
import 'package:booksphere_app/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:booksphere_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Widget _bookDetailApp({
  required String bookId,
  required BookDetailRouteArgs args,
  required Future<BookDetail> Function(Ref ref, String bookId) loader,
}) {
  return ProviderScope(
    overrides: [bookDetailProvider.overrideWith(loader)],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: BookDetailScreen(bookId: bookId, args: args),
    ),
  );
}

void main() {
  testWidgets('add mode defaults quantity to 1 and shows add button', (
    tester,
  ) async {
    await tester.pumpWidget(
      _bookDetailApp(
        bookId: '1',
        args: const BookDetailRouteArgs(mode: BookDetailMode.add),
        loader: (ref, id) async => const BookDetail(
          id: '1',
          title: 'Clean Code',
          availableQuantity: 5,
          description: 'A handbook.',
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byType(BookQuantitySelector),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.byType(BookQuantitySelector), findsOneWidget);
    expect(find.text('Add to Borrow Cart'), findsOneWidget);
  });

  testWidgets('edit mode uses initial quantity and update button', (
    tester,
  ) async {
    await tester.pumpWidget(
      _bookDetailApp(
        bookId: '1',
        args: const BookDetailRouteArgs(
          mode: BookDetailMode.edit,
          initialQuantity: 3,
        ),
        loader: (ref, id) async => const BookDetail(
          id: '1',
          title: 'Clean Code',
          availableQuantity: 5,
          description: 'A handbook.',
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byType(BookQuantitySelector),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Update Borrow Cart'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(BookQuantitySelector),
        matching: find.text('3'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('minus disabled at 1 and plus disabled at available', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BookQuantitySelector(
              quantity: 1,
              availableCopies: 2,
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final minusButtons = find.descendant(
      of: find.byType(BookQuantitySelector),
      matching: find.byIcon(Icons.remove),
    );
    await tester.tap(minusButtons);
    await tester.pump();
    // Still 1 — decrease was disabled.
    expect(
      find.descendant(
        of: find.byType(BookQuantitySelector),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: BookQuantitySelector(
              quantity: 2,
              availableCopies: 2,
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(BookQuantitySelector),
        matching: find.byIcon(Icons.add),
      ),
    );
    await tester.pump();
    expect(
      find.descendant(
        of: find.byType(BookQuantitySelector),
        matching: find.text('2'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('floating cart hidden when empty and shows total quantity', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(bottomNavigationBar: FloatingBorrowCart()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('books in borrow list'), findsNothing);

    container
        .read(borrowCartProvider.notifier)
        .addBook(
          item: const BorrowCartItem(
            bookId: '1',
            title: 'A',
            quantity: 2,
            availableCopies: 5,
          ),
        );
    container
        .read(borrowCartProvider.notifier)
        .addBook(
          item: const BorrowCartItem(
            bookId: '2',
            title: 'B',
            quantity: 1,
            availableCopies: 3,
          ),
        );
    await tester.pumpAndSettle();

    expect(find.textContaining('3 books in borrow list'), findsOneWidget);
  });

  testWidgets('borrow cart screen shows quantity and edit action', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(borrowCartProvider.notifier)
        .addBook(
          item: const BorrowCartItem(
            bookId: '1',
            title: 'Clean Code',
            author: 'Uncle Bob',
            quantity: 2,
            availableCopies: 5,
          ),
        );

    final router = GoRouter(
      initialLocation: '/borrow-cart',
      routes: [
        GoRoute(
          path: '/borrow-cart',
          builder: (context, state) => const BorrowCartScreen(),
        ),
        GoRoute(
          path: '/books/:bookId',
          builder: (context, state) {
            final args = state.extra is BookDetailRouteArgs
                ? state.extra! as BookDetailRouteArgs
                : const BookDetailRouteArgs();
            return Scaffold(
              body: Text('mode=${args.mode.name};qty=${args.initialQuantity}'),
            );
          },
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Quantity: 2'), findsOneWidget);
    expect(find.textContaining('1 book title'), findsOneWidget);
    expect(find.textContaining('2 total books'), findsOneWidget);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('mode=edit;qty=2'), findsOneWidget);
  });

  testWidgets('add to cart does not show success snackbar', (tester) async {
    await tester.pumpWidget(
      _bookDetailApp(
        bookId: '1',
        args: const BookDetailRouteArgs(mode: BookDetailMode.add),
        loader: (ref, id) async => const BookDetail(
          id: '1',
          title: 'Clean Code',
          availableQuantity: 5,
          description: 'A handbook.',
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Add to Borrow Cart'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Add to Borrow Cart'));
    await tester.pump();

    expect(find.textContaining('Added to borrow list'), findsNothing);
  });
}
