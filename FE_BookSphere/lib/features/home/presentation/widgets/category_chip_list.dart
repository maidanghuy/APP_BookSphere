import 'package:booksphere_app/features/home/data/mock_home_data.dart';
import 'package:booksphere_app/features/home/presentation/widgets/book_horizontal_card.dart';
import 'package:flutter/material.dart';

class CategoryChipList extends StatelessWidget {
  const CategoryChipList({required this.categories, super.key});

  final List<HomeCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final category in categories)
          ActionChip(
            avatar: const Icon(Icons.category_outlined, size: 18),
            label: Text(localizedHomeCategory(context, category)),
            onPressed: () {},
          ),
      ],
    );
  }
}
