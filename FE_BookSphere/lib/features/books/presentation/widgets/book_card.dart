import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/books/data/models/book_summary.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    required this.book,
    this.onTap,
    this.onAddToBorrowList,
    this.isInBorrowList = false,
    super.key,
  });

  final BookSummary book;

  /// Optional tap handler used to open Book Detail.
  final VoidCallback? onTap;

  /// Optional action to add the book to the temporary borrow list.
  final VoidCallback? onAddToBorrowList;

  final bool isInBorrowList;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    final author = (book.author == null || book.author!.trim().isEmpty)
        ? l10n.unknownAuthor
        : book.author!.trim();
    final category =
        (book.categoryName == null || book.categoryName!.trim().isEmpty)
        ? l10n.unknownCategory
        : book.categoryName!.trim();
    final availableCopies = book.availableQuantity ?? 0;
    final availabilityLabel = book.isAvailable
        ? l10n.copiesAvailable(availableCopies)
        : l10n.unavailable;
    final availabilityColor = book.isAvailable
        ? colorScheme.primary
        : colorScheme.error;

    final canAdd = book.isAvailable;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BookCoverPlaceholder(colorScheme: colorScheme),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title.isEmpty ? l10n.books : book.title,
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
                    const SizedBox(height: 2),
                    Text(
                      category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    if (book.isbn != null && book.isbn!.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'ISBN: ${book.isbn}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
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
              if (onAddToBorrowList != null)
                IconButton(
                  tooltip: l10n.addToBorrowList,
                  onPressed: canAdd ? onAddToBorrowList : null,
                  icon: Icon(
                    isInBorrowList
                        ? Icons.library_add_check
                        : Icons.library_add_outlined,
                    color: canAdd
                        ? (isInBorrowList
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant)
                        : colorScheme.onSurface.withValues(alpha: 0.38),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookCoverPlaceholder extends StatelessWidget {
  const _BookCoverPlaceholder({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 88,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.menu_book_outlined,
        color: colorScheme.onSecondaryContainer,
        size: 32,
      ),
    );
  }
}
