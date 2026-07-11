import 'package:booksphere_app/features/borrows/data/borrow_models.dart';
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

  Color _getStatusColor(BuildContext context, BorrowStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (status) {
      BorrowStatus.borrowing => Colors.blue,
      BorrowStatus.overdue => colorScheme.error,
      BorrowStatus.returned => Colors.green,
      BorrowStatus.cancelled => colorScheme.outline,
    };
  }

  Color _getStatusContainerColor(BuildContext context, BorrowStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (status) {
      BorrowStatus.borrowing => Colors.blue.withValues(alpha: 0.15),
      BorrowStatus.overdue => colorScheme.errorContainer,
      BorrowStatus.returned => Colors.green.withValues(alpha: 0.15),
      BorrowStatus.cancelled => colorScheme.surfaceContainerHighest,
    };
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
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with Borrow ID and Status Chip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Borrow #${borrow.id}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusContainerColor(context, status),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(context, status).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      _getStatusText(context, status),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getStatusColor(context, status),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 0.5),

              // Date Details
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DateItem(
                          label: 'Borrow Date',
                          value: _formatDate(borrow.borrowDate),
                          icon: Icons.calendar_today_outlined,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DateItem(
                          label: 'Due Date',
                          value: _formatDate(borrow.dueDate),
                          icon: Icons.assignment_late_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Return Date (if present)
              if (borrow.returnDate != null && borrow.returnDate!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _DateItem(
                  label: 'Return Date',
                  value: _formatDate(borrow.returnDate!),
                  icon: Icons.assignment_turned_in_outlined,
                  color: Colors.green,
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
        Column(
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
        ),
      ],
    );
  }
}
