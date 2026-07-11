import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/utils/currency_utils.dart';
import 'package:booksphere_app/core/utils/date_utils.dart';
import 'package:booksphere_app/core/widgets/app_error_view.dart';
import 'package:booksphere_app/core/widgets/app_loading.dart';
import 'package:booksphere_app/features/fines/presentation/fine_payment_screen.dart';
import 'package:booksphere_app/features/fines/presentation/widgets/fine_status_chip.dart';
import 'package:booksphere_app/features/fines/providers/fine_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FineDetailScreen extends ConsumerWidget {
  const FineDetailScreen({super.key, required this.fineId});

  final String fineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final detailAsync = ref.watch(fineDetailProvider(fineId));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.fineDetail)),
      body: detailAsync.when(
        loading: () => const AppLoading(),
        error: (_, __) => AppErrorView(
          message: l10n.loadFinesFailed,
          onRetry: () => ref.invalidate(fineDetailProvider(fineId)),
        ),
        data: (fine) {
          final isUnpaid = fine.status == 'UNPAID';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header card ──────────────────────────────
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${l10n.fineId}${fine.id}',
                              style: textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            FineStatusChip(status: fine.status),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          CurrencyUtils.formatVND(fine.amount),
                          style: textTheme.headlineSmall?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Detail card ──────────────────────────────
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        _DetailRow(
                          label: l10n.borrowId,
                          value: '${fine.borrowId}',
                        ),
                        const Divider(height: 1),
                        _DetailRow(
                          label: l10n.reason,
                          value: fine.reason,
                        ),
                        if (fine.createdFrom != null) ...[
                          const Divider(height: 1),
                          _DetailRow(
                            label: l10n.createdFrom,
                            value: fine.createdFrom!,
                          ),
                        ],
                        const Divider(height: 1),
                        _DetailRow(
                          label: l10n.createdAt,
                          value: AppDateUtils.formatDate(fine.createdAt),
                        ),
                        if (fine.paidAt != null) ...[
                          const Divider(height: 1),
                          _DetailRow(
                            label: l10n.paidAt,
                            value: AppDateUtils.formatDate(fine.paidAt),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // ── Pay button ───────────────────────────────
                if (isUnpaid) ...[
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => _openPayment(context, ref, fine.id.toString(), fine.amount),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(l10n.payFine),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _openPayment(
    BuildContext context,
    WidgetRef ref,
    String id,
    double amount,
  ) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => FinePaymentScreen(fineId: id, amount: amount),
          ),
        )
        .then((_) {
          ref.invalidate(fineDetailProvider(fineId));
          ref.read(myFinesProvider.notifier).refresh();
        });
  }
}

// ── Detail row widget ─────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
