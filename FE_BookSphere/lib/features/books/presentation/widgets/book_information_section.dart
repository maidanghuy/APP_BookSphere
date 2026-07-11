import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:flutter/material.dart';

class BookInformationSection extends StatelessWidget {
  const BookInformationSection({required this.book, super.key});

  final BookDetail book;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final rows = <_InfoRowData>[
      _InfoRowData(label: l10n.isbn, value: book.isbn),
      _InfoRowData(label: l10n.publisher, value: book.publisher),
      _InfoRowData(
        label: l10n.publicationYear,
        value: book.publishedYear?.toString(),
      ),
      _InfoRowData(label: l10n.category, value: book.categoryName),
      _InfoRowData(
        label: l10n.totalCopies,
        value: book.totalQuantity?.toString(),
      ),
      _InfoRowData(
        label: l10n.availableCopies,
        value: book.availableQuantity?.toString(),
      ),
    ].where((row) => row.value != null && row.value!.trim().isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.bookInfo,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (final row in rows)
                _InfoTile(label: row.label, value: row.value!.trim()),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRowData {
  const _InfoRowData({required this.label, required this.value});

  final String label;
  final String? value;
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
