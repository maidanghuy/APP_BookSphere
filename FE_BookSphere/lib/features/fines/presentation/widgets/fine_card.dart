import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/utils/currency_utils.dart';
import 'package:booksphere_app/core/utils/date_utils.dart';
import 'package:booksphere_app/features/fines/data/fine_models.dart';
import 'package:booksphere_app/features/fines/presentation/widgets/fine_status_chip.dart';
import 'package:flutter/material.dart';

class FineCard extends StatelessWidget {
  const FineCard({
    super.key,
    required this.fine,
    this.onTap,
    this.onPay,
  });

  final FineResponse fine;
  final VoidCallback? onTap;
  final VoidCallback? onPay;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10n.fineId}${fine.id}',
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyUtils.formatVND(fine.amount),
                          style: TextStyle(
                            color: colorScheme.error,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FineStatusChip(status: fine.status),
                ],
              ),
              const SizedBox(height: 12),
              _InfoRow(label: l10n.reason, value: fine.reason),
              _InfoRow(
                label: l10n.borrowId,
                value: '${fine.borrowId}',
              ),
              if (fine.createdAt != null)
                _InfoRow(
                  label: l10n.createdAt,
                  value: AppDateUtils.formatDate(fine.createdAt),
                ),
              if (fine.paidAt != null)
                _InfoRow(
                  label: l10n.paidAt,
                  value: AppDateUtils.formatDate(fine.paidAt),
                ),
              if (fine.status == 'UNPAID' && onPay != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: onPay,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                    ),
                    child: Text(l10n.payNow),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
