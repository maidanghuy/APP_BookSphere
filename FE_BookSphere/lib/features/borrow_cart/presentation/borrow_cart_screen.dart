import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/widgets/confirm_dialog.dart';
import 'package:booksphere_app/features/borrow_cart/data/borrow_cart_item.dart';
import 'package:booksphere_app/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BorrowCartScreen extends ConsumerWidget {
  const BorrowCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final cart = ref.watch(borrowCartProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.borrowList),
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
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      final notifier = ref.read(borrowCartProvider.notifier);
                      return _BorrowCartTile(
                        item: item,
                        onIncrement: () =>
                            notifier.incrementQuantity(item.bookId),
                        onDecrement: () {
                          final wasLast = item.quantity <= 1;
                          notifier.decrementQuantity(item.bookId);
                          if (wasLast) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.removedFromBorrowList),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                persist: false,
                              ),
                            );
                          }
                        },
                        onRemove: () {
                          notifier.removeBook(item.bookId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.removedFromBorrowList),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              persist: false,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.borrowListItemCount(cart.itemCount),
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.confirmBorrowLaterNote,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
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
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final BorrowCartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
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
        child: Row(
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
                    availabilityLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: availabilityColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _QuantityButton(
                        icon: Icons.remove,
                        tooltip: l10n.quantity,
                        onPressed: onDecrement,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.add,
                        tooltip: l10n.quantity,
                        onPressed: item.isAvailable ? onIncrement : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: l10n.removeFromBorrowList,
              onPressed: onRemove,
              icon: Icon(Icons.delete_outline, color: colorScheme.error),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        visualDensity: VisualDensity.compact,
        icon: Icon(icon, size: 20),
      ),
    );
  }
}
