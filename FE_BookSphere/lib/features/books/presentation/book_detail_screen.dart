import 'package:booksphere_app/core/constants/app_message_keys.dart';
import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/utils/error_message_mapper.dart';
import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_availability_card.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_detail_header.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_detail_skeleton.dart';
import 'package:booksphere_app/features/books/presentation/widgets/book_information_section.dart';
import 'package:booksphere_app/features/books/providers/book_detail_provider.dart';
import 'package:booksphere_app/features/borrow_cart/data/borrow_cart_item.dart';
import 'package:booksphere_app/features/borrow_cart/presentation/borrow_cart_helpers.dart';
import 'package:booksphere_app/features/borrow_cart/presentation/widgets/borrow_cart_icon.dart';
import 'package:booksphere_app/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({required this.bookId, super.key});

  final String bookId;

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
          const BorrowCartIcon(),
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
    return RefreshIndicator(
      onRefresh: () => ref.refreshBookDetail(trimmedId),
      child: _BookDetailBody(book: book),
    );
  }

  void _backToBooks(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/main');
  }
}

class _BookDetailBody extends ConsumerWidget {
  const _BookDetailBody({required this.book});

  final BookDetail book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final description = book.description?.trim();
    final alreadyInCart = ref.watch(
      borrowCartProvider.select((s) => s.contains(book.id)),
    );
    final canAdd = book.isAvailable;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
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
        const SizedBox(height: 28),
        // Temporary borrow cart only — real borrow API is a later task.
        FilledButton.icon(
          onPressed: canAdd
              ? () {
                  final feedback = addBookToBorrowCart(
                    ref,
                    BorrowCartItem.fromBookDetail(book),
                  );
                  showBorrowCartFeedback(context, ref, feedback);
                }
              : null,
          icon: Icon(
            alreadyInCart
                ? Icons.library_add_check
                : Icons.library_add_outlined,
          ),
          label: Text(l10n.addToBorrowList),
        ),
      ],
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
