import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';

class FineStatusChip extends StatelessWidget {
  const FineStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (color, bgColor) = _colors(status);
    final label = _label(status, l10n);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  (Color, Color) _colors(String status) {
    return switch (status) {
      'UNPAID' => (Colors.orange.shade800, Colors.orange.shade50),
      'PAID' => (Colors.green.shade800, Colors.green.shade50),
      'CANCELLED' => (Colors.grey.shade700, Colors.grey.shade200),
      _ => (Colors.grey.shade700, Colors.grey.shade200),
    };
  }

  String _label(String status, dynamic l10n) {
    return switch (status) {
      'UNPAID' => l10n.fineStatusUnpaid as String,
      'PAID' => l10n.fineStatusPaid as String,
      'CANCELLED' => l10n.fineStatusCancelled as String,
      _ => status,
    };
  }
}
