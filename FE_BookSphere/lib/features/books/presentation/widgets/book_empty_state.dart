import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/books/data/models/book_filter.dart';
import 'package:flutter/material.dart';

class BookEmptyState extends StatelessWidget {
  const BookEmptyState({
    required this.hasActiveFilters,
    this.filter,
    this.onClearFilters,
    super.key,
  });

  final bool hasActiveFilters;
  final BookFilter? filter;
  final VoidCallback? onClearFilters;

  BookEmptyReason get _reason {
    final active = filter;
    if (active == null) {
      return hasActiveFilters ? BookEmptyReason.filters : BookEmptyReason.none;
    }
    if (!active.hasActiveFilters) {
      return BookEmptyReason.none;
    }
    if (active.hasOnlyKeyword) {
      return BookEmptyReason.search;
    }
    return BookEmptyReason.filters;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final reason = _reason;

    final message = switch (reason) {
      BookEmptyReason.none => l10n.noBooks,
      BookEmptyReason.search => l10n.noSearchResults,
      BookEmptyReason.filters => l10n.noFilterResults,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              reason == BookEmptyReason.none
                  ? Icons.menu_book_outlined
                  : Icons.search_off_outlined,
              size: 72,
              color: colorScheme.outline.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (reason == BookEmptyReason.search) ...[
              const SizedBox(height: 8),
              Text(
                l10n.tryDifferentSearch,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (hasActiveFilters && onClearFilters != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onClearFilters,
                child: Text(l10n.clearAll),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum BookEmptyReason { none, search, filters }
