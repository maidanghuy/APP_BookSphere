import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';

class PaymentMethodSheet extends StatefulWidget {
  const PaymentMethodSheet({super.key, required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  State<PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<PaymentMethodSheet> {
  String? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final methods = [
      ('CASH', l10n.cash, Icons.money_outlined),
      ('BANK_TRANSFER', l10n.bankTransfer, Icons.account_balance_outlined),
      ('E_WALLET', l10n.eWallet, Icons.account_balance_wallet_outlined),
    ];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.selectPaymentMethod,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...methods.map((item) {
              final (value, label, icon) = item;
              return RadioListTile<String>(
                title: Row(
                  children: [
                    Icon(icon, size: 20),
                    const SizedBox(width: 12),
                    Text(label),
                  ],
                ),
                value: value,
                groupValue: _selectedMethod,
                onChanged: (val) => setState(() => _selectedMethod = val),
                contentPadding: EdgeInsets.zero,
              );
            }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selectedMethod != null
                    ? () {
                        widget.onSelected(_selectedMethod!);
                        Navigator.pop(context);
                      }
                    : null,
                child: Text(l10n.confirmSelection),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
