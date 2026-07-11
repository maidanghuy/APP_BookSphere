import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/books/data/models/book_filter.dart';
import 'package:flutter/material.dart';

class ActiveFilterChips extends StatelessWidget {
  const ActiveFilterChips({
    required this.filter,
    required this.categoryName,
    required this.onClearCategory,
    required this.onClearAvailability,
    required this.onResetAll,
    super.key,
  });

  final BookFilter filter;
  final String? categoryName;
  final VoidCallback onClearCategory;
  final VoidCallback onClearAvailability;
  final VoidCallback onResetAll;

  @override
  Widget build(BuildContext context) {
    if (!filter.hasCategory && !filter.hasAvailability) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.activeFilters,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (filter.hasCategory)
              InputChip(
                label: Text(
                  '${l10n.category}: ${categoryName ?? filter.categoryId}',
                ),
                onDeleted: onClearCategory,
                deleteIconColor: colorScheme.onSurfaceVariant,
                backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.55,
                ),
              ),
            if (filter.hasAvailability)
              InputChip(
                label: Text(
                  filter.availability == BookAvailabilityFilter.available
                      ? l10n.available
                      : l10n.unavailable,
                ),
                onDeleted: onClearAvailability,
                deleteIconColor: colorScheme.onSurfaceVariant,
                backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.55,
                ),
              ),
            ActionChip(
              label: Text(l10n.clearAll),
              onPressed: onResetAll,
              backgroundColor: colorScheme.secondaryContainer.withValues(
                alpha: 0.7,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
