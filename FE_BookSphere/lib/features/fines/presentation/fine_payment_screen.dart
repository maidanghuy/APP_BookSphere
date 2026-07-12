import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/network/api_exception.dart';
import 'package:booksphere_app/core/utils/currency_utils.dart';
import 'package:booksphere_app/core/widgets/confirm_dialog.dart';
import 'package:booksphere_app/features/fines/data/fine_models.dart';
import 'package:booksphere_app/features/fines/data/fine_repository.dart';
import 'package:booksphere_app/features/fines/presentation/widgets/payment_method_sheet.dart';
import 'package:booksphere_app/features/fines/providers/fine_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String _selectedPaymentStatus = 'SUCCESS';
  bool _isSubmitting = false;
  late TextEditingController _amountController;
  final _formKey = GlobalKey<FormState>();

  static const _paymentStatuses = ['SUCCESS', 'PENDING', 'FAILED'];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.amount.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.payFine)),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Total Amount to Pay',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
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

              // Amount input field
              Text(l10n.paymentAmountLabel, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: l10n.paymentAmountHint,
                  border: const OutlineInputBorder(),
                  suffixText: '₫',
                ),
              ),
              const SizedBox(height: 24),

              // Payment method picker
              Text(l10n.selectPaymentMethod, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.payment),
                  title: Text(_selectedMethod != null
                      ? _labelForMethod(l10n, _selectedMethod!)
                      : l10n.selectPaymentMethod),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showPaymentMethodSheet,
                ),
              ),
              const SizedBox(height: 24),

              // Simulate result picker
              Text(l10n.simulatePaymentResult,
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: _paymentStatuses.map((status) {
                    return RadioListTile<String>(
                      value: status,
                      groupValue: _selectedPaymentStatus,
                      onChanged: (val) =>
                          setState(() => _selectedPaymentStatus = val!),
                      title: Text(_labelForStatus(l10n, status)),
                      secondary: Icon(
                        _iconForStatus(status),
                        color: _colorForStatus(status),
                      ),
                    );
                  }).toList(),
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
                      : Text(l10n.confirm),
                ),
              ),
            ],
          ),
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
        onSelected: (method) => setState(() => _selectedMethod = method),
      ),
    );
  }

  String _labelForMethod(dynamic l10n, String method) {
    return switch (method) {
      'CASH' => l10n.cash,
      'BANK_TRANSFER' => l10n.bankTransfer,
      'E_WALLET' => l10n.eWallet,
      _ => method,
    };
  }

  String _labelForStatus(dynamic l10n, String status) {
    return switch (status) {
      'SUCCESS' => l10n.paymentResultSuccess,
      'PENDING' => l10n.paymentResultPending,
      'FAILED' => l10n.paymentResultFailed,
      _ => status,
    };
  }

  IconData _iconForStatus(String status) {
    return switch (status) {
      'SUCCESS' => Icons.check_circle_outline,
      'PENDING' => Icons.hourglass_empty,
      'FAILED' => Icons.cancel_outlined,
      _ => Icons.help_outline,
    };
  }

  Color _colorForStatus(String status) {
    return switch (status) {
      'SUCCESS' => Colors.green,
      'PENDING' => Colors.orange,
      'FAILED' => Colors.red,
      _ => Colors.grey,
    };
  }

  Future<void> _submitPayment() async {
    final l10n = context.l10n;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: l10n.payFine,
        content: 'Are you sure you want to proceed with this payment?',
        confirmText: l10n.confirm,
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(fineRepositoryProvider);
      final enteredAmount = double.tryParse(_amountController.text.trim());
      final response = await repository.payFine(
        widget.fineId,
        PayFineRequest(
          paymentMethod: _selectedMethod!,
          paymentStatus: _selectedPaymentStatus,
          amount: enteredAmount,
        ),
      );

      if (!mounted) return;

      final status = response.paymentStatus;

      if (status == 'SUCCESS') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.paymentSuccessMessage),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      } else if (status == 'PENDING') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.paymentPendingMessage),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        // FAILED
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.paymentFailedMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } on FineException catch (e) {
      if (!mounted) return;
      final msg = switch (e.statusCode) {
        403 => l10n.paymentForbidden,
        404 => l10n.paymentNotFound,
        422 => l10n.paymentAlreadyPaid,
        400 => _resolve400Message(l10n, e),
        _ => e.message,
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.unknownError),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _resolve400Message(dynamic l10n, FineException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('amount')) return l10n.paymentInvalidAmount;
    if (msg.contains('method')) return l10n.paymentInvalidMethod;
    if (msg.contains('status')) return l10n.paymentInvalidStatus;
    return e.message;
  }
}
