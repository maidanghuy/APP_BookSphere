import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/home/data/mock_home_data.dart';
import 'package:flutter/material.dart';

class BookHorizontalCard extends StatelessWidget {
  const BookHorizontalCard({required this.book, super.key});

  final HomeBook book;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 168,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.menu_book_outlined,
                      size: 48,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                book.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                localizedHomeCategory(context, book.category),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String localizedHomeCategory(BuildContext context, HomeCategory category) {
  final l10n = context.l10n;

  return switch (category) {
    HomeCategory.programming => l10n.categoryProgramming,
    HomeCategory.novel => l10n.categoryNovel,
    HomeCategory.science => l10n.categoryScience,
    HomeCategory.history => l10n.categoryHistory,
    HomeCategory.technology => l10n.categoryTechnology,
  };
}
