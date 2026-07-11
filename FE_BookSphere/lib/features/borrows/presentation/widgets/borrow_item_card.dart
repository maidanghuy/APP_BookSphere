import 'package:booksphere_app/features/borrows/data/borrow_models.dart';
import 'package:booksphere_app/features/borrows/providers/borrow_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BorrowItemCard extends ConsumerWidget {
  const BorrowItemCard({required this.item, super.key});

  final BorrowItemResponse item;

  static const Map<int, Map<String, String>> _fallbackBooks = {
    1: {'title': 'Clean Code', 'author': 'Robert C. Martin'},
    2: {'title': 'Effective Java', 'author': 'Joshua Bloch'},
    3: {'title': 'Spring Microservices in Action', 'author': 'John Carnell'},
    4: {'title': 'Designing Data-Intensive Applications', 'author': 'Martin Kleppmann'},
    5: {'title': 'Database System Concepts', 'author': 'Abraham Silberschatz'},
    6: {'title': 'SQL Performance Explained', 'author': 'Markus Winand'},
    7: {'title': 'Artificial Intelligence: A Modern Approach', 'author': 'Stuart Russell'},
    8: {'title': 'Hands-On Machine Learning', 'author': 'Aurélien Géron'},
    9: {'title': 'The Lean Startup', 'author': 'Eric Ries'},
    10: {'title': 'Good to Great', 'author': 'Jim Collins'},
  };

  Color _getStatusColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (status.toUpperCase()) {
      'BORROWED' => Colors.blue,
      'RETURNED' => Colors.green,
      'LOST' => colorScheme.error,
      _ => colorScheme.outline,
    };
  }

  Color _getStatusContainerColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (status.toUpperCase()) {
      'BORROWED' => Colors.blue.withValues(alpha: 0.15),
      'RETURNED' => Colors.green.withValues(alpha: 0.15),
      'LOST' => colorScheme.errorContainer,
      _ => colorScheme.surfaceContainerHighest,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String displayTitle;
    final String displayAuthor;

    if (item.bookTitle.isNotEmpty) {
      displayTitle = item.bookTitle;
      displayAuthor = item.bookAuthor;
    } else if (_fallbackBooks.containsKey(item.bookId)) {
      displayTitle = _fallbackBooks[item.bookId]!['title']!;
      displayAuthor = _fallbackBooks[item.bookId]!['author']!;
    } else {
      final bookDetailAsync = ref.watch(bookDetailProvider(item.bookId));
      displayTitle = bookDetailAsync.maybeWhen(
        data: (book) => book.title,
        orElse: () => 'Book #${item.bookId}',
      );
      displayAuthor = bookDetailAsync.maybeWhen(
        data: (book) => book.author,
        orElse: () => 'Unknown Author',
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.menu_book,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayAuthor,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusContainerColor(context, item.status),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(context, item.status).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    item.status,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(context, item.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Qty: ${item.quantity}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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
