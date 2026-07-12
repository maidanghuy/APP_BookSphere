import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/utils/error_message_mapper.dart';
import 'package:booksphere_app/core/widgets/confirm_dialog.dart';
import 'package:booksphere_app/features/books/presentation/book_detail_route_args.dart';
import 'package:booksphere_app/features/books/providers/book_detail_provider.dart' as book_details_prov;
import 'package:booksphere_app/features/books/providers/book_list_provider.dart' as book_list_prov;
import 'package:booksphere_app/features/borrow_cart/data/borrow_cart_item.dart';
import 'package:booksphere_app/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:booksphere_app/features/borrows/data/borrow_models.dart';
import 'package:booksphere_app/features/borrows/providers/borrow_provider.dart';
import 'package:booksphere_app/features/notification/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BorrowCartScreen extends ConsumerWidget {
  const BorrowCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final cart = ref.watch(borrowCartProvider);
    final borrowCreateState = ref.watch(borrowCreateControllerProvider);
    final isLoading = borrowCreateState.isLoading;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.borrowCart),
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, ref),
              child: Text(l10n.clearBorrowList),
            ),
        ],
      ),
      body: cart.isEmpty
          ? _BorrowCartEmptyState(onBrowseBooks: () => context.go('/main'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.distinctBooks(cart.distinctBookCount),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.totalBooks(cart.totalQuantity),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return _BorrowCartTile(
                        item: item,
                        onEdit: () {
                          context.push(
                            '/books/${item.bookId}',
                            extra: BookDetailRouteArgs(
                              mode: BookDetailMode.edit,
                              initialQuantity: item.quantity,
                            ),
                          );
                        },
                        onRemove: () {
                          ref
                              .read(borrowCartProvider.notifier)
                              .removeBook(item.bookId);
                        },
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilledButton(
                          onPressed: isLoading
                              ? null
                              : () => _handleCheckout(context, ref, cart),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(l10n.borrowBook),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _handleCheckout(
    BuildContext context,
    WidgetRef ref,
    BorrowCartState cart,
  ) async {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final today = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 90)),
    );

    if (selectedDate == null) return;

    if (!context.mounted) return;
    final dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: l10n.confirmBorrowTitle,
        content: l10n.confirmBorrowCartMessage(cart.totalQuantity, dateString),
        confirmText: l10n.confirm,
      ),
    );

    if (confirmed != true) return;

    final items = cart.items
        .map(
          (item) => BorrowItemRequest(
            bookId: int.parse(item.bookId),
            quantity: item.quantity,
          ),
        )
        .toList();

    final success = await ref
        .read(borrowCreateControllerProvider.notifier)
        .createCartBorrow(items: items, dueDate: selectedDate);

    if (success) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.borrowSuccess),
          backgroundColor: Colors.green,
        ),
      );

      ref.invalidate(borrowListProvider);
      ref.invalidate(book_list_prov.bookListProvider);
      ref.invalidate(notificationControllerProvider);

      for (final item in cart.items) {
        ref.invalidate(bookDetailProvider(int.parse(item.bookId)));
        ref.invalidate(book_details_prov.bookDetailProvider(item.bookId));
      }

      ref.read(borrowCartProvider.notifier).clearCart();

      if (context.mounted) {
        context.go('/main?tab=2');
      }
    } else {
      if (context.mounted) {
        final errorState = ref.read(borrowCreateControllerProvider);
        final message = ErrorMessageMapper.mapCode(context, errorState.errorCode);
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(message), backgroundColor: colorScheme.error),
        );
      }
    }
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: l10n.clearBorrowList,
        content: l10n.clearBorrowListConfirm,
        confirmText: l10n.clearAll,
      ),
    );
    if (confirmed == true && context.mounted) {
      ref.read(borrowCartProvider.notifier).clearCart();
    }
  }
}

class _BorrowCartEmptyState extends StatelessWidget {
  const _BorrowCartEmptyState({required this.onBrowseBooks});

  final VoidCallback onBrowseBooks;

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
              Icons.library_add_outlined,
              size: 72,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.borrowListEmpty,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.borrowListEmptyDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onBrowseBooks,
              child: Text(l10n.browseBooks),
            ),
          ],
        ),
      ),
    );
  }
}

class _BorrowCartTile extends StatelessWidget {
  const _BorrowCartTile({
    required this.item,
    required this.onEdit,
    required this.onRemove,
  });

  final BorrowCartItem item;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final author = (item.author == null || item.author!.trim().isEmpty)
        ? l10n.unknownAuthor
        : item.author!.trim();
    final availabilityLabel = item.isAvailable
        ? l10n.copiesAvailable(item.availableCopies)
        : l10n.unavailable;
    final availabilityColor = item.isAvailable
        ? colorScheme.primary
        : colorScheme.error;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 76,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.menu_book_outlined,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title.isEmpty ? l10n.books : item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${l10n.quantity}: ${item.quantity}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        availabilityLabel,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: availabilityColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(l10n.editCartItem),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRemove,
                    icon: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: colorScheme.error,
                    ),
                    label: Text(
                      l10n.removeFromCart,
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
