import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/books/data/models/book_detail.dart';
import 'package:flutter/material.dart';

class BookDetailHeader extends StatelessWidget {
  const BookDetailHeader({required this.book, super.key});

  final BookDetail book;

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

    return Column(
      children: [
        const _BookCoverPlaceholder(),
        const SizedBox(height: 20),
        Text(
          book.title.isEmpty ? l10n.books : book.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          author,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          category,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _BookCoverPlaceholder extends StatelessWidget {
  const _BookCoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Backend BookDetailResponse does not provide a cover URL.
    return Container(
      width: 160,
      height: 220,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.menu_book_outlined,
        size: 72,
        color: colorScheme.onSecondaryContainer,
      ),
    );
  }
}
