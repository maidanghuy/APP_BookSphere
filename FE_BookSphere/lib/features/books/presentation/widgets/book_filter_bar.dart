import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/books/data/models/book_filter.dart';
import 'package:booksphere_app/features/books/data/models/category_summary.dart';
import 'package:flutter/material.dart';

/// Compact inline filter controls kept for compatibility/tests.
/// Primary UX now uses [BookFilterBottomSheet] + active chips.
class BookFilterBar extends StatelessWidget {
  const BookFilterBar({
    required this.categories,
    required this.selectedCategoryId,
    required this.availabilityFilter,
    required this.onCategoryChanged,
    required this.onAvailabilityChanged,
    super.key,
  });

  final List<CategorySummary> categories;
  final String? selectedCategoryId;
  final BookAvailabilityFilter availabilityFilter;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<BookAvailabilityFilter> onAvailabilityChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String?>(
          key: ValueKey(selectedCategoryId ?? 'all'),
          initialValue: selectedCategoryId,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: l10n.allCategories,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(l10n.allCategories),
            ),
            ...categories.map(
              (category) => DropdownMenuItem<String?>(
                value: category.id,
                child: Text(category.name, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _AvailabilityChip(
                label: l10n.allAvailability,
                selected: availabilityFilter == BookAvailabilityFilter.all,
                onSelected: () =>
                    onAvailabilityChanged(BookAvailabilityFilter.all),
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 8),
              _AvailabilityChip(
                label: l10n.available,
                selected:
                    availabilityFilter == BookAvailabilityFilter.available,
                onSelected: () =>
                    onAvailabilityChanged(BookAvailabilityFilter.available),
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 8),
              _AvailabilityChip(
                label: l10n.unavailable,
                selected:
                    availabilityFilter == BookAvailabilityFilter.unavailable,
                onSelected: () =>
                    onAvailabilityChanged(BookAvailabilityFilter.unavailable),
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvailabilityChip extends StatelessWidget {
  const _AvailabilityChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.colorScheme,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: selected,
      selectedColor: colorScheme.primary,
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.5,
      ),
      onSelected: (_) => onSelected(),
    );
  }
}
