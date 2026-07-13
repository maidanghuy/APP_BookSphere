import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/utils/error_message_mapper.dart';
import 'package:booksphere_app/core/widgets/app_empty_state.dart';
import 'package:booksphere_app/core/widgets/app_error_view.dart';
import 'package:booksphere_app/core/widgets/app_loading.dart';
import 'package:booksphere_app/features/borrows/presentation/widgets/borrow_card.dart';
import 'package:booksphere_app/features/borrows/providers/borrow_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyBorrowListScreen extends ConsumerWidget {
  const MyBorrowListScreen({super.key});

  Widget _buildFilterChips(
    BuildContext context,
    WidgetRef ref,
    String? selectedStatus,
  ) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    final List<Map<String, String?>> filters = [
      {'value': null, 'label': l10n.statusAll},
      {'value': 'BORROWING', 'label': l10n.statusBorrowing},
      {'value': 'OVERDUE', 'label': l10n.statusOverdue},
      {'value': 'RETURNED', 'label': l10n.statusReturned},
      {'value': 'CANCELLED', 'label': l10n.statusCancelled},
    ];

    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedStatus == filter['value'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                filter['label'] ?? '',
                style: TextStyle(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: colorScheme.primary,
              backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(borrowListProvider.notifier)
                      .changeFilter(filter['value']);
                }
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(borrowListProvider);

    ref.listen(borrowListProvider, (previous, next) {
      if (next.errorCode != null &&
          next.borrows.isNotEmpty &&
          next.errorCode != previous?.errorCode) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.refreshFailed)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myBorrow),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
      ),
      body: Column(
        children: [
          _buildFilterChips(context, ref, state.selectedStatus),
          Expanded(
            child: state.isLoading && state.borrows.isEmpty
                ? AppLoading(message: l10n.loadingData)
                : state.errorCode != null && state.borrows.isEmpty
                ? AppErrorView(
                    title: l10n.somethingWentWrong,
                    message: ErrorMessageMapper.mapCode(
                      context,
                      state.errorCode,
                    ),
                    onRetry: () =>
                        ref.read(borrowListProvider.notifier).loadBorrows(),
                  )
                : RefreshIndicator(
                    onRefresh: () =>
                        ref.read(borrowListProvider.notifier).refresh(),
                    child: state.borrows.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: AppEmptyState(
                                  icon: Icons.library_books_outlined,
                                  title: l10n.noBorrows,
                                  description: l10n.noBorrowsDescription,
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: state.borrows.length,
                            itemBuilder: (context, index) {
                              final borrow = state.borrows[index];
                              return BorrowCard(
                                borrow: borrow,
                                onTap: () {
                                  context.push('/borrows/${borrow.id}');
                                },
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
