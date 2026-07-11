import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';

class BookEmptyState extends StatelessWidget {
  const BookEmptyState({
    required this.hasActiveFilters,
    this.onClearFilters,
    super.key,
  });

  final bool hasActiveFilters;
  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasActiveFilters
                  ? Icons.search_off_outlined
                  : Icons.menu_book_outlined,
              size: 72,
              color: colorScheme.outline.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              hasActiveFilters ? l10n.noBooksFound : l10n.noBooks,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasActiveFilters && onClearFilters != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onClearFilters,
                child: Text(l10n.clearFilters),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
