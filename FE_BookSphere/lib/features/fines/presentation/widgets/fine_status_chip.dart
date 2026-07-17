import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/widgets/status_chip.dart';
import 'package:flutter/material.dart';

class FineStatusChip extends StatelessWidget {
  const FineStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = _label(status, l10n);
    return StatusChip(status: status, label: label);
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
