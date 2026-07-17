import 'package:booksphere_app/features/borrows/data/borrow_models.dart';
import 'package:booksphere_app/core/theme/app_spacing.dart';
import 'package:booksphere_app/core/theme/app_radius.dart';
import 'package:booksphere_app/core/widgets/status_chip.dart';
import 'package:booksphere_app/shared/enums/borrow_status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BorrowCard extends StatelessWidget {
  const BorrowCard({required this.borrow, required this.onTap, super.key});

  final BorrowResponse borrow;
  final VoidCallback onTap;

  String _formatDate(String dateStr) {
    try {
      final parsed = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (_) {
      return dateStr;
    }
  }

  String _getStatusText(BuildContext context, BorrowStatus status) {
    return switch (status) {
      BorrowStatus.borrowing => 'BORROWING',
      BorrowStatus.overdue => 'OVERDUE',
      BorrowStatus.returned => 'RETURNED',
      BorrowStatus.cancelled => 'CANCELLED',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final status = borrow.borrowStatus;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgBorder,
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgBorder,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: AppSpacing.sm,
                spacing: AppSpacing.sm,
                children: [
                  Text(
                    'Borrow #${borrow.id}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  StatusChip(status: _getStatusText(context, status)),
                ],
              ),
              const Divider(height: 24, thickness: 0.5),

              // Date Details
              LayoutBuilder(builder: (context, constraints) {
                final compact = constraints.maxWidth < 320;
                final items = [
                  _DateItem(
                          label: 'Borrow Date',
                          value: _formatDate(borrow.borrowDate),
                          icon: Icons.calendar_today_outlined,
                        ),
                  _DateItem(
                          label: 'Due Date',
                          value: _formatDate(borrow.dueDate),
                          icon: Icons.assignment_late_outlined,
                        ),
                ];
                return compact
                    ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [items.first, const SizedBox(height: AppSpacing.sm), items.last])
                    : Row(children: [Expanded(child: items.first), const SizedBox(width: AppSpacing.sm), Expanded(child: items.last)]);
              }),

              // Return Date (if present)
              if (borrow.returnDate != null && borrow.returnDate!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _DateItem(
                  label: 'Return Date',
                  value: _formatDate(borrow.returnDate!),
                  icon: Icons.assignment_turned_in_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${borrow.totalItems} Book(s)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateItem extends StatelessWidget {
  const _DateItem({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayColor = color ?? colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(icon, size: 16, color: displayColor.withValues(alpha: 0.7)),
        const SizedBox(width: 8),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: color != null ? FontWeight.bold : null,
              ),
            ),
          ],
        )),
      ],
    );
  }
}
