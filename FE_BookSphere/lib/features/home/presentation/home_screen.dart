import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/home/data/mock_home_data.dart';
import 'package:booksphere_app/features/home/presentation/widgets/book_horizontal_card.dart';
import 'package:booksphere_app/features/home/presentation/widgets/home_header.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.onViewBooks,
    required this.onViewBorrows,
    required this.onViewFines,
    super.key,
  });

  final VoidCallback onViewBooks;
  final VoidCallback onViewBorrows;
  final VoidCallback onViewFines;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    if (!_isLoading) {
      setState(() => _isLoading = true);
    }

    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  bool get _isEmpty =>
      MockHomeData.activeBorrowCount == 0 &&
      MockHomeData.overdueBorrowCount == 0 &&
      MockHomeData.unpaidFineCount == 0 &&
      !MockHomeData.hasLatestNotification;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadDashboard,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const HomeHeader(),
            const SizedBox(height: 24),
            if (_isLoading)
              const _HomeLoadingState()
            else if (_isEmpty)
              _HomeEmptyState(onViewBooks: widget.onViewBooks)
            else ...[
              Text(
                l10n.borrowingOverview,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const _SummaryGrid(
                activeBorrowCount: MockHomeData.activeBorrowCount,
                overdueBorrowCount: MockHomeData.overdueBorrowCount,
                unpaidFineCount: MockHomeData.unpaidFineCount,
              ),
              const SizedBox(height: 24),
              _BorrowedBooksSection(onViewBorrows: widget.onViewBorrows),
              const SizedBox(height: 24),
              const _LatestNotificationCard(),
              const SizedBox(height: 24),
              _QuickActions(
                onViewBooks: widget.onViewBooks,
                onViewBorrows: widget.onViewBorrows,
                onViewFines: widget.onViewFines,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({
    required this.activeBorrowCount,
    required this.overdueBorrowCount,
    required this.unpaidFineCount,
  });

  final int activeBorrowCount;
  final int overdueBorrowCount;
  final int unpaidFineCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth >= 720
            ? (constraints.maxWidth - 24) / 3
            : constraints.maxWidth;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SummaryCard(
              width: width,
              icon: Icons.library_books_outlined,
              label: l10n.activeBorrows,
              value: activeBorrowCount,
            ),
            _SummaryCard(
              width: width,
              icon: Icons.schedule_outlined,
              label: l10n.overdueBorrows,
              value: overdueBorrowCount,
            ),
            _SummaryCard(
              width: width,
              icon: Icons.payments_outlined,
              label: l10n.unpaidFines,
              value: unpaidFineCount,
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.width,
    required this.icon,
    required this.label,
    required this.value,
  });

  final double width;
  final IconData icon;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(child: Text(label)),
              Text(
                '$value',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BorrowedBooksSection extends StatelessWidget {
  const _BorrowedBooksSection({required this.onViewBorrows});
  final VoidCallback onViewBorrows;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.currentlyBorrowedBooks,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(onPressed: onViewBorrows, child: Text(l10n.viewBorrows)),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: MockHomeData.borrowedBooks.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                BookHorizontalCard(book: MockHomeData.borrowedBooks[index]),
          ),
        ),
      ],
    );
  }
}

class _LatestNotificationCard extends StatelessWidget {
  const _LatestNotificationCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.notifications_active_outlined),
        title: Text(l10n.latestNotification),
        subtitle: Text(l10n.mockLatestNotification),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onViewBooks,
    required this.onViewBorrows,
    required this.onViewFines,
  });

  final VoidCallback onViewBooks;
  final VoidCallback onViewBorrows;
  final VoidCallback onViewFines;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.icon(
          onPressed: onViewBooks,
          icon: const Icon(Icons.menu_book_outlined),
          label: Text(l10n.viewBooks),
        ),
        OutlinedButton.icon(
          onPressed: onViewBorrows,
          icon: const Icon(Icons.library_books_outlined),
          label: Text(l10n.viewBorrows),
        ),
        OutlinedButton.icon(
          onPressed: onViewFines,
          icon: const Icon(Icons.payments_outlined),
          label: Text(l10n.viewFines),
        ),
      ],
    );
  }
}

class _HomeLoadingState extends StatelessWidget {
  const _HomeLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 64),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _HomeEmptyState extends StatelessWidget {
  const _HomeEmptyState({required this.onViewBooks});
  final VoidCallback onViewBooks;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.auto_stories_outlined, size: 48),
            const SizedBox(height: 12),
            Text(l10n.homeEmptyTitle),
            const SizedBox(height: 12),
            FilledButton(onPressed: onViewBooks, child: Text(l10n.viewBooks)),
          ],
        ),
      ),
    );
  }
}
