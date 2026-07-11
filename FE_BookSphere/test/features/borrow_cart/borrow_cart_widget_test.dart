import 'package:booksphere_app/features/books/presentation/widgets/book_search_filter_bar.dart';
import 'package:booksphere_app/features/borrow_cart/data/borrow_cart_item.dart';
import 'package:booksphere_app/features/borrow_cart/presentation/borrow_cart_screen.dart';
import 'package:booksphere_app/features/borrow_cart/presentation/widgets/borrow_cart_icon.dart';
import 'package:booksphere_app/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:booksphere_app/features/books/presentation/book_detail_screen.dart';
import 'package:booksphere_app/features/books/providers/book_detail_provider.dart';
import 'package:booksphere_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Widget _localizationShell({required Widget home}) {
  return ProviderScope(
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

Widget _bookDetailApp({
  required String bookId,
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
      home: BookDetailScreen(bookId: bookId),
    ),
  );
}

void main() {
  testWidgets('cart badge shows item count', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container
        .read(borrowCartProvider.notifier)
        .addBook(
          const BorrowCartItem(
            bookId: '1',
            title: 'Clean Code',
            availableCopies: 2,
          ),
        );

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
          home: Scaffold(appBar: AppBar(actions: const [BorrowCartIcon()])),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
    expect(find.byIcon(Icons.library_add_outlined), findsOneWidget);
  });

  testWidgets('book detail shows Add to Borrow List and adds book', (
    tester,
  ) async {
    await tester.pumpWidget(
      _bookDetailApp(
        bookId: '1',
        loader: (ref, id) async {
          return const BookDetail(
            id: '1',
            title: 'Clean Code',
            author: 'Robert C. Martin',
            availableQuantity: 3,
            totalQuantity: 5,
            description: 'A handbook.',
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Clean Code'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byType(FilledButton),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Add to Borrow List'), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.textContaining('Added to borrow list'), findsOneWidget);
    expect(find.text('Add to Borrow List'), findsOneWidget);
    expect(find.byIcon(Icons.library_add_check), findsOneWidget);
  });

  testWidgets('borrow cart screen shows item, remove and empty state', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(borrowCartProvider.notifier)
        .addBook(
          const BorrowCartItem(
            bookId: '1',
            title: 'Clean Code',
            author: 'Robert C. Martin',
            availableCopies: 2,
          ),
        );

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
          home: const BorrowCartScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Clean Code'), findsOneWidget);
    expect(find.textContaining('1 book in borrow list'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove from borrow list'));
    await tester.pumpAndSettle();

    expect(find.text('Your borrow list is empty.'), findsOneWidget);
    expect(find.text('Browse Books'), findsOneWidget);
  });

  testWidgets('clear all removes every cart item', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(borrowCartProvider.notifier);
    notifier.addBook(
      const BorrowCartItem(bookId: '1', title: 'A', availableCopies: 1),
    );
    notifier.addBook(
      const BorrowCartItem(bookId: '2', title: 'B', availableCopies: 1),
    );

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
          home: const BorrowCartScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Clear all'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Clear all'));
    await tester.pumpAndSettle();

    expect(find.text('Your borrow list is empty.'), findsOneWidget);
    expect(container.read(borrowCartProvider).itemCount, 0);
  });

  testWidgets('search filter bar is compact without overflow at 360 width', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _localizationShell(
        home: Scaffold(
          body: BookSearchFilterBar(
            controller: controller,
            searchKeyword: '',
            hasActiveNonKeywordFilters: true,
            onChanged: (_) {},
            onSubmitted: (_) {},
            onClearSearch: () {},
            onOpenFilters: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Filters'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets('borrow cart icon navigates via go router path', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              Scaffold(appBar: AppBar(actions: const [BorrowCartIcon()])),
        ),
        GoRoute(
          path: '/borrow-cart',
          builder: (context, state) => const BorrowCartScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
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

    await tester.tap(find.byIcon(Icons.library_add_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Your borrow list is empty.'), findsOneWidget);
  });
}
