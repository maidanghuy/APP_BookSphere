import 'package:booksphere_app/core/constants/app_message_keys.dart';
import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/utils/error_message_mapper.dart';
import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:booksphere_app/features/books/presentation/book_detail_route_args.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_availability_card.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_detail_header.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_detail_skeleton.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_information_section.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_quantity_selector.dart';
import 'package:booksphere_app/features/books/providers/book_detail_provider.dart';
import 'package:booksphere_app/features/borrow_cart/data/borrow_cart_item.dart';
import 'package:booksphere_app/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({
    required this.bookId,
    this.args = const BookDetailRouteArgs(),
    super.key,
  });

  final String bookId;
  final BookDetailRouteArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final trimmedId = bookId.trim();

    if (trimmedId.isEmpty) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(l10n.bookDetails),
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
        ),
        body: BookDetailNotFoundBody(
          onBackToBooks: () => _backToBooks(context),
        ),
      );
    }

    final asyncBook = ref.watch(bookDetailProvider(trimmedId));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.bookDetails),
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        actions: [
          IconButton(
            tooltip: l10n.retry,
            onPressed: () {
              ref.refreshBookDetail(trimmedId);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(context, ref, trimmedId, asyncBook),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    String trimmedId,
    AsyncValue<BookDetail> asyncBook,
  ) {
    if (asyncBook.hasError) {
      return BookDetailErrorBody(
        error: asyncBook.error!,
        onRetry: () => ref.refreshBookDetail(trimmedId),
        onBackToBooks: () => _backToBooks(context),
      );
    }

    if (asyncBook.isLoading || !asyncBook.hasValue) {
      return const BookDetailSkeleton();
    }

    final book = asyncBook.requireValue;
    return _BookDetailLoadedBody(book: book, args: args);
  }

  void _backToBooks(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/main');
  }
}

class _BookDetailLoadedBody extends ConsumerStatefulWidget {
  const _BookDetailLoadedBody({required this.book, required this.args});

  final BookDetail book;
  final BookDetailRouteArgs args;

  @override
  ConsumerState<_BookDetailLoadedBody> createState() =>
      _BookDetailLoadedBodyState();
}

class _BookDetailLoadedBodyState extends ConsumerState<_BookDetailLoadedBody> {
  late int _quantity;
  bool _initialized = false;

  BookDetail get book => widget.book;
  BookDetailMode get mode => widget.args.mode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    _initialized = true;
    _quantity = _resolveInitialQuantity();
  }

  int _resolveInitialQuantity() {
    final available = book.availableQuantity ?? 0;
    if (available <= 0) {
      return 1;
    }

    if (mode == BookDetailMode.edit) {
      final fromArgs = widget.args.initialQuantity;
      final fromCart = ref.read(borrowCartProvider).quantityOf(book.id);
      final preferred = fromArgs ?? fromCart;
      if (preferred < 1) {
        return 1;
      }
      if (preferred > available) {
        return available;
      }
      return preferred;
    }

    return 1;
  }

  bool get _canSubmit {
    final available = book.availableQuantity ?? 0;
    if (available <= 0) {
      return false;
    }
    return _quantity >= 1 && _quantity <= available;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          persist: false,
        ),
      );
  }

  void _navigateAfterSuccess() {
    final router = GoRouter.maybeOf(context);
    if (mode == BookDetailMode.edit) {
      if (router != null) {
        if (router.canPop()) {
          router.pop();
        } else {
          router.go('/borrow-cart');
        }
        return;
      }
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      return;
    }

    // Add mode → Book List (Main tab).
    if (router != null) {
      if (router.canPop()) {
        router.pop();
      } else {
        router.go('/main');
      }
      return;
    }
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _onSubmit() {
    final l10n = context.l10n;
    final available = book.availableQuantity ?? 0;

    if (available <= 0) {
      _showError(l10n.bookUnavailable);
      return;
    }
    if (_quantity < 1) {
      _showError(l10n.quantityMinimumError);
      return;
    }
    if (_quantity > available) {
      _showError(l10n.quantityExceedsAvailable(available));
      return;
    }

    final notifier = ref.read(borrowCartProvider.notifier);

    if (mode == BookDetailMode.edit) {
      final result = notifier.updateQuantity(
        bookId: book.id,
        quantity: _quantity,
        availableCopies: available,
      );
      switch (result) {
        case BorrowCartUpdateResult.updated:
          _navigateAfterSuccess();
          return;
        case BorrowCartUpdateResult.notFound:
          _showError(l10n.bookUnavailable);
          return;
        case BorrowCartUpdateResult.unavailable:
          _showError(l10n.bookUnavailable);
          return;
        case BorrowCartUpdateResult.invalidQuantity:
          _showError(l10n.quantityExceedsAvailable(available));
          return;
      }
    }

    final alreadyInCart = notifier.containsBook(book.id);
    if (alreadyInCart) {
      _showError(l10n.bookAlreadyInCart);
      return;
    }

    final result = notifier.addBook(
      item: BorrowCartItem.fromBookDetail(book, quantity: _quantity),
    );
    switch (result) {
      case BorrowCartAddResult.added:
        // No success popup — return to Book List (Main tab).
        _navigateAfterSuccess();
        return;
      case BorrowCartAddResult.alreadyExists:
        _showError(l10n.bookAlreadyInCart);
        return;
      case BorrowCartAddResult.unavailable:
        _showError(l10n.bookUnavailable);
        return;
      case BorrowCartAddResult.invalidQuantity:
        _showError(l10n.quantityExceedsAvailable(available));
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final description = book.description?.trim();
    final available = book.availableQuantity ?? 0;
    final isEdit = mode == BookDetailMode.edit;

    // Warn when cart quantity exceeds freshly loaded availability.
    final cartQty = ref.watch(
      borrowCartProvider.select((s) => s.quantityOf(book.id)),
    );
    final quantityExceedsFreshAvailability =
        isEdit && cartQty > 0 && available > 0 && cartQty > available;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () => ref.refreshBookDetail(book.id),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            BookDetailHeader(book: book),
            const SizedBox(height: 20),
            BookAvailabilityCard(book: book),
            const SizedBox(height: 20),
            BookInformationSection(book: book),
            const SizedBox(height: 20),
            Text(
              l10n.description,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              (description == null || description.isEmpty)
                  ? l10n.noDescriptionAvailable
                  : description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            BookQuantitySelector(
              quantity: _quantity,
              availableCopies: available,
              onChanged: (value) => setState(() => _quantity = value),
            ),
            if (quantityExceedsFreshAvailability) ...[
              const SizedBox(height: 12),
              Text(
                l10n.quantityExceedsAvailable(available),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: isEdit
              ? FilledButton.icon(
                  onPressed: _canSubmit ? _onSubmit : null,
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l10n.updateBorrowCart),
                )
              : Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _canSubmit ? _onSubmit : null,
                        icon: const Icon(Icons.library_add_outlined),
                        label: Text(l10n.addToBorrowCart),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _canSubmit
                            ? () {
                                context.push(
                                  '/borrows/create?bookId=${book.id}&quantity=$_quantity',
                                );
                              }
                            : null,
                        icon: const Icon(Icons.book_outlined),
                        label: Text(l10n.borrowBook),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class BookDetailNotFoundBody extends StatelessWidget {
  const BookDetailNotFoundBody({required this.onBackToBooks, super.key});

  final VoidCallback onBackToBooks;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 72,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.bookNotFound,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.bookNotFoundDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: onBackToBooks,
              child: Text(l10n.backToBooks),
            ),
          ],
        ),
      ),
    );
  }
}

class BookDetailErrorBody extends StatelessWidget {
  const BookDetailErrorBody({
    required this.error,
    required this.onRetry,
    required this.onBackToBooks,
    super.key,
  });

  final Object error;
  final Future<void> Function() onRetry;
  final VoidCallback onBackToBooks;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final code = bookDetailErrorCode(error);
    final statusCode = bookDetailErrorStatusCode(error);
    final isNotFound = code == 'BOOK_NOT_FOUND' || statusCode == 404;

    if (isNotFound) {
      return BookDetailNotFoundBody(onBackToBooks: onBackToBooks);
    }

    final message = _mapErrorMessage(context, code, statusCode);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.checkConnectionAndRetry,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onRetry();
              },
              child: Text(l10n.retry),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: onBackToBooks, child: Text(l10n.backToBooks)),
          ],
        ),
      ),
    );
  }

  String _mapErrorMessage(BuildContext context, String? code, int? statusCode) {
    final l10n = context.l10n;
    if (statusCode == 403 || code == 'FORBIDDEN') {
      return l10n.accessDenied;
    }
    if (code == AppMessageKeys.networkError || code == 'NETWORK_ERROR') {
      return ErrorMessageMapper.mapCode(context, AppMessageKeys.networkError);
    }
    if (code == AppMessageKeys.serverUnavailable ||
        code == 'SERVER_UNAVAILABLE') {
      return ErrorMessageMapper.mapCode(
        context,
        AppMessageKeys.serverUnavailable,
      );
    }
    return l10n.loadBookDetailFailed;
  }
}
