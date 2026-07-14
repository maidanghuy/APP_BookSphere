import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/widgets/app_loading_button.dart';
import 'package:booksphere_app/features/auth/providers/logout_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final logoutState = ref.watch(logoutControllerProvider);

    final onPressed = logoutState.isLoading
        ? null
        : () => _confirmAndLogout(context, ref);
    final icon = logoutState.isLoading
        ? const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Icon(Icons.logout);

    if (compact) {
      return IconButton.filledTonal(
        tooltip: l10n.logout,
        onPressed: onPressed,
        icon: icon,
        style: IconButton.styleFrom(
          minimumSize: const Size.square(48),
          maximumSize: const Size.square(48),
          padding: EdgeInsets.zero,
        ),
      );
    }

    return FilledButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(l10n.logout),
    );
  }

  Future<void> _confirmAndLogout(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.logoutConfirmTitle),
          content: Text(l10n.logoutConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true || !context.mounted) {
      return;
    }

    final didReachLogoutApi = await ref
        .read(logoutControllerProvider.notifier)
        .logout();

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          didReachLogoutApi ? l10n.logoutSuccess : l10n.logoutFailedButCleared,
        ),
      ),
    );
    context.go('/login');
  }
}
