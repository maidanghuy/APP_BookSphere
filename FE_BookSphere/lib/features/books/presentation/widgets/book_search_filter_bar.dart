import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';

/// Responsive search field + filter button for Book List.
///
/// Narrow screens (< 420): stacked column.
/// Wider screens: search and filter on one row with spacing.
class BookSearchFilterBar extends StatelessWidget {
  const BookSearchFilterBar({
    required this.controller,
    required this.searchKeyword,
    required this.hasActiveNonKeywordFilters,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClearSearch,
    required this.onOpenFilters,
    super.key,
  });

  final TextEditingController controller;
  final String searchKeyword;
  final bool hasActiveNonKeywordFilters;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClearSearch;
  final VoidCallback onOpenFilters;

  static const double compactBreakpoint = 420;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final searchField = TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: l10n.searchByTitleAuthorIsbn,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchKeyword.isEmpty
            ? null
            : IconButton(
                tooltip: l10n.clearSearch,
                onPressed: onClearSearch,
                icon: const Icon(Icons.clear),
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    final filterButton = FilledButton.tonalIcon(
      onPressed: onOpenFilters,
      icon: Badge(
        isLabelVisible: hasActiveNonKeywordFilters,
        child: const Icon(Icons.tune),
      ),
      label: Text(l10n.filters),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < compactBreakpoint;

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                searchField,
                const SizedBox(height: 12),
                Align(alignment: Alignment.centerRight, child: filterButton),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: searchField),
              const SizedBox(width: 12),
              filterButton,
            ],
          );
        },
      ),
    );
  }
}
