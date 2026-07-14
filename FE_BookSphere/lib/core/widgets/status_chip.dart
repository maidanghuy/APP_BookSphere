import 'package:booksphere_app/core/theme/app_colors.dart';
import 'package:booksphere_app/core/theme/app_radius.dart';
import 'package:booksphere_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({required this.status, this.label, super.key});

  final String status;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toUpperCase();
    final color = switch (normalized) {
      'BORROWING' => AppColors.info,
      'OVERDUE' => AppColors.error,
      'RETURNED' || 'PAID' => AppColors.success,
      'UNPAID' => AppColors.warning,
      _ => Theme.of(context).colorScheme.onSurfaceVariant,
    };
    final icon = switch (normalized) {
      'BORROWING' => Icons.auto_stories_outlined,
      'OVERDUE' => Icons.warning_amber_rounded,
      'RETURNED' => Icons.assignment_turned_in_outlined,
      'UNPAID' => Icons.schedule_outlined,
      'PAID' => Icons.check_circle_outline,
      _ => Icons.info_outline,
    };

    return Semantics(
      label: label ?? normalized,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: AppRadius.smBorder,
          border: Border.all(color: color.withValues(alpha: .35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(label ?? normalized, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
