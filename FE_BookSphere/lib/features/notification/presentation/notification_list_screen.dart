import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/core/utils/error_message_mapper.dart';
import 'package:booksphere_app/core/widgets/app_empty_state.dart';
import 'package:booksphere_app/core/widgets/app_error_view.dart';
import 'package:booksphere_app/core/widgets/app_loading.dart';
import 'package:booksphere_app/features/notification/data/notification_models.dart';
import 'package:booksphere_app/features/notification/presentation/widgets/notification_tile.dart';
import 'package:booksphere_app/features/notification/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationListScreen extends ConsumerWidget {
  const NotificationListScreen({
    required this.onOpenBorrow,
    required this.onOpenFine,
    super.key,
  });

  final VoidCallback onOpenBorrow;
  final VoidCallback onOpenFine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationControllerProvider);
    final controller = ref.read(notificationControllerProvider.notifier);
    final l10n = context.l10n;
    ref.listen(notificationControllerProvider, (previous, next) {
      if (next.errorCode != null &&
          next.notifications.isNotEmpty &&
          next.errorCode != previous?.errorCode) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorMessageMapper.mapCode(context, next.errorCode)),
          ),
        );
      }
    });

    if (state.isLoading && state.notifications.isEmpty) {
      return AppLoading(message: l10n.loadingData);
    }
    if (state.errorCode != null && state.notifications.isEmpty) {
      return AppErrorView(
        title: l10n.somethingWentWrong,
        message: ErrorMessageMapper.mapCode(context, state.errorCode),
        onRetry: controller.load,
      );
    }

    final items = state.visibleNotifications;
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            l10n.notificationListTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(l10n.allNotifications)),
              ButtonSegment(value: true, label: Text(l10n.unreadNotifications)),
            ],
            selected: {state.showUnreadOnly},
            onSelectionChanged: (values) =>
                controller.setUnreadOnly(values.first),
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.5,
              child: AppEmptyState(
                icon: Icons.notifications_none,
                title: state.showUnreadOnly
                    ? l10n.noUnreadNotifications
                    : l10n.noNotifications,
                description: l10n.noNotificationsDescription,
              ),
            )
          else
            for (final item in items)
              NotificationTile(
                notification: item,
                isMarkingAsRead: state.markingAsReadIds.contains(item.id),
                onTap: () => _open(context, controller, item),
              ),
        ],
      ),
    );
  }

  Future<void> _open(
    BuildContext context,
    NotificationController controller,
    AppNotification item,
  ) async {
    final success = await controller.markAsRead(item.id);
    if (!context.mounted) return;
    if (!success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.markAsReadFailed)));
      return;
    }
    if (item.referenceId == null) return;
    switch (item.type) {
      case AppNotificationType.borrow:
      case AppNotificationType.returnBook:
      case AppNotificationType.dueSoon:
      case AppNotificationType.overdue:
        onOpenBorrow();
      case AppNotificationType.fine:
      case AppNotificationType.payment:
        onOpenFine();
      case AppNotificationType.system:
      case AppNotificationType.unknown:
        return;
    }
  }
}
