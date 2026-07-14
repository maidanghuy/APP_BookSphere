import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/widgets/app_loading_button.dart';
import 'package:booksphere_app/core/widgets/app_error_view.dart';
import 'package:booksphere_app/core/widgets/app_loading.dart';
import 'package:booksphere_app/core/utils/error_message_mapper.dart';
import 'package:booksphere_app/features/books/providers/book_detail_provider.dart'
    as book_details_prov;
import 'package:booksphere_app/features/books/providers/book_list_provider.dart'
    as book_list_prov;
import 'package:booksphere_app/features/borrows/providers/borrow_provider.dart';
import 'package:booksphere_app/features/notification/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BorrowCreateScreen extends ConsumerStatefulWidget {
  const BorrowCreateScreen({
    required this.bookId,
    this.initialQuantity,
    super.key,
  });

  final int? bookId;
  final int? initialQuantity;

  @override
  ConsumerState<BorrowCreateScreen> createState() => _BorrowCreateScreenState();
}

class _BorrowCreateScreenState extends ConsumerState<BorrowCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _quantityController;
  DateTime? _selectedDueDate;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: '${widget.initialQuantity ?? 1}',
    );
    // Default due date to 14 days from today
    _selectedDueDate = DateTime.now().add(const Duration(days: 14));
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final initialDate =
        _selectedDueDate != null && !_selectedDueDate!.isBefore(today)
        ? _selectedDueDate!
        : tomorrow;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDueDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          23,
          59,
          59,
        );
      });
    }
  }

  void _submitBorrow(
    BuildContext context,
    int availableQuantity,
    String bookTitle,
  ) async {
    if (widget.bookId == null) return;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDueDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.dueDateRequired)));
      return;
    }

    final quantity = int.tryParse(_quantityController.text) ?? 1;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.confirmBorrowTitle),
        content: Text(
          context.l10n.confirmBorrowMessage(
            quantity,
            bookTitle,
            DateFormat('yyyy-MM-dd').format(_selectedDueDate!),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.borrowBook),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    final success = await ref
        .read(borrowCreateControllerProvider.notifier)
        .createBorrow(
          bookId: widget.bookId!,
          quantity: quantity,
          dueDate: _selectedDueDate!,
        );

    if (success) {
      ref.invalidate(bookDetailProvider(widget.bookId!));
      ref.invalidate(
        book_details_prov.bookDetailProvider(widget.bookId!.toString()),
      );
      ref.invalidate(book_list_prov.bookListProvider);
      ref.invalidate(borrowListProvider);
      ref.invalidate(notificationControllerProvider);

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.borrowSuccess),
          backgroundColor: Colors.green,
        ),
      );

      if (context.mounted) {
        context.go('/main?tab=2');
      }
    } else {
      final errorState = ref.read(borrowCreateControllerProvider);
      if (context.mounted) {
        final message = ErrorMessageMapper.mapCode(
          context,
          errorState.errorCode,
          statusCode: errorState.errorStatusCode,
        );
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.bookId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.borrowBook)),
        body: Center(child: Text(l10n.unknownError)),
      );
    }

    final bookDetailAsync = ref.watch(bookDetailProvider(widget.bookId!));
    final controllerState = ref.watch(borrowCreateControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.borrowBook),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
      ),
      body: bookDetailAsync.when(
        data: (book) {
          if (!book.isActive) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.block_outlined,
                      size: 64,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.bookInactive,
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // Book Information Card
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 110,
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.menu_book_outlined,
                            size: 40,
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                book.author,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (book.isbn != null &&
                                  book.isbn!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'ISBN: ${book.isbn}',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: book.availableQuantity > 0
                                      ? colorScheme.primaryContainer
                                      : colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  book.availableQuantity > 0
                                      ? '${l10n.quantity}: ${book.availableQuantity}'
                                      : l10n.bookOutOfStock,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: book.availableQuantity > 0
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onErrorContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Form title
                Text(
                  l10n.borrowBook,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Quantity TextField
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  enabled: !controllerState.isLoading,
                  decoration: InputDecoration(
                    labelText: l10n.quantity,
                    prefixIcon: const Icon(Icons.pin_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.quantityRequired;
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return l10n.quantityInvalid;
                    }
                    if (quantity > book.availableQuantity) {
                      return l10n.quantityExceeded;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Due Date Picker Field
                InkWell(
                  onTap: controllerState.isLoading
                      ? null
                      : () => _selectDueDate(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.dueDate,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedDueDate != null
                                    ? DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(_selectedDueDate!)
                                    : l10n.selectDueDate,
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Submit Button
                AppLoadingButton(
                  label: l10n.borrowBook,
                  icon: Icons.menu_book_outlined,
                  isLoading: controllerState.isLoading,
                  onPressed:
                      controllerState.isLoading || book.availableQuantity <= 0
                      ? null
                      : () => _submitBorrow(
                          context,
                          book.availableQuantity,
                          book.title,
                        ),
                ),
              ],
            ),
          );
        },
        loading: () => AppLoading(message: l10n.loadingData),
        error: (error, _) => AppErrorView(
          title: l10n.somethingWentWrong,
          message: l10n.networkError,
          onRetry: () => ref.invalidate(bookDetailProvider(widget.bookId!)),
        ),
      ),
    );
  }
}
