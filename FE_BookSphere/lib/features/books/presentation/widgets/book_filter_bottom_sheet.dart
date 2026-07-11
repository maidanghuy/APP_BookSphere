import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/books/data/models/book_filter.dart';
import 'package:booksphere_app/features/books/data/models/category_summary.dart';
import 'package:flutter/material.dart';

Future<BookFilter?> showBookFilterBottomSheet({
  required BuildContext context,
  required BookFilter initialFilter,
  required List<CategorySummary> categories,
  String? categoriesErrorMessage,
  VoidCallback? onRetryCategories,
}) {
  return showModalBottomSheet<BookFilter>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      return BookFilterBottomSheet(
        initialFilter: initialFilter,
        categories: categories,
        categoriesErrorMessage: categoriesErrorMessage,
        onRetryCategories: onRetryCategories,
      );
    },
  );
}

class BookFilterBottomSheet extends StatefulWidget {
  const BookFilterBottomSheet({
    required this.initialFilter,
    required this.categories,
    this.categoriesErrorMessage,
    this.onRetryCategories,
    super.key,
  });

  final BookFilter initialFilter;
  final List<CategorySummary> categories;
  final String? categoriesErrorMessage;
  final VoidCallback? onRetryCategories;

  @override
  State<BookFilterBottomSheet> createState() => _BookFilterBottomSheetState();
}

class _BookFilterBottomSheetState extends State<BookFilterBottomSheet> {
  late BookFilter _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.filters,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.selectCategory,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          if (widget.categoriesErrorMessage != null) ...[
            Text(
              widget.categoriesErrorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
              ),
            ),
            if (widget.onRetryCategories != null)
              TextButton(
                onPressed: widget.onRetryCategories,
                child: Text(l10n.retry),
              ),
            const SizedBox(height: 8),
          ],
          DropdownButtonFormField<String?>(
            key: ValueKey(_draft.categoryId ?? 'all'),
            initialValue: _draft.categoryId,
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
              ...widget.categories.map(
                (category) => DropdownMenuItem<String?>(
                  value: category.id,
                  child: Text(category.name, overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _draft = _draft.copyWith(
                  categoryId: value,
                  clearCategory: value == null,
                );
              });
            },
          ),
          const SizedBox(height: 16),
          Text(
            l10n.availability,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _DraftChip(
                label: l10n.allAvailability,
                selected: _draft.availability == BookAvailabilityFilter.all,
                onSelected: () {
                  setState(() {
                    _draft = _draft.copyWith(
                      availability: BookAvailabilityFilter.all,
                    );
                  });
                },
              ),
              _DraftChip(
                label: l10n.available,
                selected:
                    _draft.availability == BookAvailabilityFilter.available,
                onSelected: () {
                  setState(() {
                    _draft = _draft.copyWith(
                      availability: BookAvailabilityFilter.available,
                    );
                  });
                },
              ),
              _DraftChip(
                label: l10n.unavailable,
                selected:
                    _draft.availability == BookAvailabilityFilter.unavailable,
                onSelected: () {
                  setState(() {
                    _draft = _draft.copyWith(
                      availability: BookAvailabilityFilter.unavailable,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _draft = BookFilter(keyword: _draft.keyword);
                    });
                  },
                  child: Text(l10n.resetFilters),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(_draft),
                  child: Text(l10n.applyFilters),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DraftChip extends StatelessWidget {
  const _DraftChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
