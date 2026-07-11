import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:flutter/material.dart';

class BookAvailabilityCard extends StatelessWidget {
  const BookAvailabilityCard({required this.book, super.key});

  final BookDetail book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    final available = book.availableQuantity ?? 0;
    final total = book.totalQuantity;
    final isAvailable = book.isAvailable;

    final statusLabel = isAvailable ? l10n.available : l10n.unavailable;
    final copiesLabel = total == null
        ? l10n.copiesAvailable(available)
        : l10n.copiesAvailableOfTotal(available, total);

    final statusColor = isAvailable ? colorScheme.primary : colorScheme.error;
    final background = isAvailable
        ? colorScheme.primaryContainer.withValues(alpha: 0.55)
        : colorScheme.errorContainer.withValues(alpha: 0.55);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isAvailable ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: statusColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  copiesLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
