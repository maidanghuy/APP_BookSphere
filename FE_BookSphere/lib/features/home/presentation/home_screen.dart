import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/home/data/mock_home_data.dart';
import 'package:booksphere_app/features/home/presentation/widgets/book_horizontal_card.dart';
import 'package:booksphere_app/features/home/presentation/widgets/category_chip_list.dart';
import 'package:booksphere_app/features/home/presentation/widgets/home_header.dart';
import 'package:booksphere_app/features/home/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch(String keyword) {
    if (keyword.trim().isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.l10n.searchFuturePlaceholder)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            const SizedBox(height: 24),
            SearchBarWidget(
              controller: _searchController,
              onSubmitted: _submitSearch,
            ),
            const SizedBox(height: 28),
            _SectionTitle(title: l10n.featuredBooks),
            const SizedBox(height: 12),
            const _HorizontalBookList(books: MockHomeData.featuredBooks),
            const SizedBox(height: 28),
            _SectionTitle(title: l10n.categories),
            const SizedBox(height: 12),
            const CategoryChipList(categories: MockHomeData.categories),
            const SizedBox(height: 28),
            _SectionTitle(title: l10n.recommendedForYou),
            const SizedBox(height: 12),
            const _HorizontalBookList(books: MockHomeData.recommendedBooks),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _HorizontalBookList extends StatelessWidget {
  const _HorizontalBookList({required this.books});

  final List<HomeBook> books;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => BookHorizontalCard(book: books[index]),
      ),
    );
  }
}
