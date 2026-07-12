import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/utils/error_message_mapper.dart';
import 'package:booksphere_app/features/books/providers/book_detail_provider.dart' as book_details_prov;
import 'package:booksphere_app/features/books/providers/book_list_provider.dart' as book_list_prov;
import 'package:booksphere_app/features/borrows/data/borrow_models.dart';
import 'package:booksphere_app/features/borrows/presentation/widgets/borrow_item_card.dart';
import 'package:booksphere_app/features/borrows/providers/borrow_provider.dart';
import 'package:booksphere_app/shared/enums/borrow_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BorrowDetailScreen extends ConsumerWidget {
  const BorrowDetailScreen({required this.borrowId, super.key});

  final int? borrowId;

  String _formatDate(String dateStr) {
    try {
      final parsed = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd HH:mm').format(parsed);
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
    final l10n = context.l10n;
    return switch (status) {
      BorrowStatus.borrowing => l10n.statusBorrowing,
      BorrowStatus.overdue => l10n.statusOverdue,
      BorrowStatus.returned => l10n.statusReturned,
      BorrowStatus.cancelled => l10n.statusCancelled,
    };
  }

  void _handleReturn(BuildContext context, WidgetRef ref, BorrowDetailResponse borrow) {
    if (borrowId == null) return;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final status = borrow.borrowStatus;
    final isOverdue = status == BorrowStatus.overdue;

    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmReturnTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.confirmReturnMessage),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Column(
                  children: [
                    _DialogInfoRow(label: 'Borrow ID', value: '#${borrow.id}'),
                    const SizedBox(height: 8),
                    _DialogInfoRow(label: 'Borrow Date', value: _formatDate(borrow.borrowDate)),
                    const SizedBox(height: 8),
                    _DialogInfoRow(label: 'Due Date', value: _formatDate(borrow.dueDate)),
                    const SizedBox(height: 8),
                    _DialogInfoRow(label: 'Status', value: _getStatusText(context, status)),
                  ],
                ),
              ),
              if (isOverdue) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: colorScheme.error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.overdueReturnWarning,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onErrorContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.returnBook),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true) {
        final success = await ref.read(borrowReturnControllerProvider.notifier).returnBorrow(borrowId!);
        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.returnSuccess),
              backgroundColor: Colors.green,
            ),
          );
          
          final detailAsync = ref.read(borrowDetailsProvider(borrowId!));
          detailAsync.whenData((detail) {
            for (final item in detail.items) {
              ref.invalidate(bookDetailProvider(item.bookId));
              ref.invalidate(
                book_details_prov.bookDetailProvider(item.bookId.toString()),
              );
            }
          });
          ref.invalidate(book_list_prov.bookListProvider);
          ref.invalidate(borrowDetailsProvider(borrowId!));
          ref.invalidate(borrowListProvider);
        } else if (context.mounted) {
          final errorState = ref.read(borrowReturnControllerProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ErrorMessageMapper.mapCode(context, errorState.errorCode)),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (borrowId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.borrowDetails)),
        body: Center(child: Text(l10n.unknownError)),
      );
    }

    final detailAsync = ref.watch(borrowDetailsProvider(borrowId!));
    final returnState = ref.watch(borrowReturnControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.borrowDetails} #$borrowId'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(borrowDetailsProvider(borrowId!)),
          ),
        ],
      ),
      body: Stack(
        children: [
          detailAsync.when(
            data: (borrow) {
              final status = borrow.borrowStatus;
              final isOverdue = status == BorrowStatus.overdue;
              final canReturn = status == BorrowStatus.borrowing || status == BorrowStatus.overdue;

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (isOverdue) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.error.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, color: colorScheme.error, size: 28),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    l10n.overdueWarning,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: colorScheme.onErrorContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Information',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
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
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                _InfoRow(
                                  label: 'Member Name',
                                  value: borrow.memberName.isNotEmpty ? borrow.memberName : 'Member #${borrow.userId}',
                                ),
                                const SizedBox(height: 12),
                                _InfoRow(
                                  label: 'Username',
                                  value: borrow.username.isNotEmpty ? borrow.username : 'User #${borrow.userId}',
                                ),
                                const SizedBox(height: 12),
                                _InfoRow(label: 'Borrow Date', value: _formatDate(borrow.borrowDate)),
                                const SizedBox(height: 12),
                                _InfoRow(label: 'Due Date', value: _formatDate(borrow.dueDate)),
                                if (borrow.returnDate != null && borrow.returnDate!.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  _InfoRow(
                                    label: 'Return Date',
                                    value: _formatDate(borrow.returnDate!),
                                    valueColor: Colors.green,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Borrowed Books',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...borrow.items.map((item) => BorrowItemCard(item: item)),
                      ],
                    ),
                  ),
                  if (canReturn) ...[
                    SafeArea(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: returnState.isLoading ? null : () => _handleReturn(context, ref, borrow),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: returnState.isLoading
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: colorScheme.onPrimary,
                                  ),
                                )
                              : Text(
                                  l10n.returnBook,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      l10n.networkError,
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(borrowDetailsProvider(borrowId!)),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (returnState.isLoading) ...[
            const ModalBarrier(
              dismissible: false,
              color: Colors.black12,
            ),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ],
      ),
    );
  }
}

class _DialogInfoRow extends StatelessWidget {
  const _DialogInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
