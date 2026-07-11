import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/widgets/app_empty_state.dart';
import 'package:booksphere_app/core/widgets/app_error_view.dart';
import 'package:booksphere_app/core/widgets/app_loading.dart';
import 'package:booksphere_app/features/fines/data/fine_models.dart';
import 'package:booksphere_app/features/fines/presentation/fine_detail_screen.dart';
import 'package:booksphere_app/features/fines/presentation/fine_payment_screen.dart';
import 'package:booksphere_app/features/fines/presentation/widgets/fine_card.dart';
import 'package:booksphere_app/features/fines/providers/fine_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyFineListScreen extends ConsumerStatefulWidget {
  const MyFineListScreen({super.key});

  @override
  ConsumerState<MyFineListScreen> createState() => _MyFineListScreenState();
}

class _MyFineListScreenState extends ConsumerState<MyFineListScreen> {
  // null means "ALL"
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final finesAsync = ref.watch(myFinesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myFines)),
      body: Column(
        children: [
          _FilterBar(
            selected: _selectedStatus,
            onSelected: _onFilterSelected,
          ),
          Expanded(
            child: finesAsync.when(
              loading: () => const AppLoading(),
              error: (error, _) => AppErrorView(
                message: l10n.loadFinesFailed,
                onRetry: () =>
                    ref.read(myFinesProvider.notifier).refresh(),
              ),
              data: (fines) {
                if (fines.isEmpty) {
                  return AppEmptyState(
                    message: l10n.noFinesFound,
                    icon: Icons.receipt_long_outlined,
                  );
                }
                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(myFinesProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: fines.length,
                    itemBuilder: (context, index) {
                      final fine = fines[index];
                      return FineCard(
                        fine: fine,
                        onTap: () => _openDetail(fine),
                        onPay: fine.status == 'UNPAID'
                            ? () => _openPayment(fine)
                            : null,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onFilterSelected(String? status) {
    setState(() => _selectedStatus = status);
    ref.read(myFinesProvider.notifier).loadFines(status: status);
  }

  void _openDetail(FineResponse fine) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => FineDetailScreen(fineId: fine.id.toString()),
          ),
        )
        .then((_) => ref.read(myFinesProvider.notifier).refresh());
  }

  void _openPayment(FineResponse fine) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => FinePaymentScreen(
              fineId: fine.id.toString(),
              amount: fine.amount,
            ),
          ),
        )
        .then((_) => ref.read(myFinesProvider.notifier).refresh());
  }
}

// ── Filter bar ────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onSelected});

  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final filters = [
      (null, l10n.fineStatusAll),
      ('UNPAID', l10n.fineStatusUnpaid),
      ('PAID', l10n.fineStatusPaid),
      ('CANCELLED', l10n.fineStatusCancelled),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((item) {
          final (value, label) = item;
          final isSelected = selected == value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => onSelected(value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
