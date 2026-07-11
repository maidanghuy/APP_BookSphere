import 'package:booksphere_app/features/fines/data/fine_models.dart';
import 'package:booksphere_app/features/fines/providers/fine_provider.dart';
import 'package:booksphere_app/features/fines/presentation/widgets/payment_method_sheet.dart';
import 'package:booksphere_app/core/utils/currency_utils.dart';
import 'package:booksphere_app/core/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinePaymentScreen extends ConsumerStatefulWidget {
  final String fineId;
  final double amount;

  const FinePaymentScreen({
    super.key,
    required this.fineId,
    required this.amount,
  });

  @override
  ConsumerState<FinePaymentScreen> createState() => _FinePaymentScreenState();
}

class _FinePaymentScreenState extends ConsumerState<FinePaymentScreen> {
  String? _selectedMethod;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pay Fine')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('Total Amount to Pay',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    Text(
                      CurrencyUtils.formatVND(widget.amount),
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Payment Method', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.payment),
                title: Text(_selectedMethod != null
                    ? _getLabelForMethod(_selectedMethod!)
                    : 'Select payment method'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showPaymentMethodSheet,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_selectedMethod != null && !_isSubmitting)
                    ? _submitPayment
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Confirm Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => PaymentMethodSheet(
        onSelected: (method) {
          setState(() {
            _selectedMethod = method;
          });
        },
      ),
    );
  }

  String _getLabelForMethod(String method) {
    return switch (method) {
      'CASH' => 'Cash',
      'BANK_TRANSFER' => 'Bank Transfer',
      'E_WALLET' => 'E-Wallet',
      _ => method,
    };
  }

  Future<void> _submitPayment() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ConfirmDialog(
        title: 'Confirm Payment',
        content: 'Are you sure you want to proceed with this payment?',
        confirmText: 'Pay',
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(fineRepositoryProvider);
      await repository.payFine(
          widget.fineId, PayFineRequest(paymentMethod: _selectedMethod!));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fine paid successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Return to detail screen which will automatically reload
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
