import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BorrowCartIcon extends ConsumerWidget {
  const BorrowCartIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final itemCount = ref.watch(borrowCartProvider.select((s) => s.itemCount));

    return Badge(
      isLabelVisible: itemCount > 0,
      label: Text('$itemCount'),
      child: IconButton(
        tooltip: l10n.borrowList,
        onPressed: () => context.push('/borrow-cart'),
        icon: const Icon(Icons.library_add_outlined),
      ),
    );
  }
}
