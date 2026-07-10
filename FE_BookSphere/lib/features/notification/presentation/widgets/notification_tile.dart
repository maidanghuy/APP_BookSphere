import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:booksphere_app/features/notification/data/notification_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.notification,
    required this.isMarkingAsRead,
    required this.onTap,
    super.key,
  });

  final AppNotification notification;
  final bool isMarkingAsRead;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = notification.createdAt;
    return Card(
      color: notification.isRead ? null : colors.primaryContainer,
      child: ListTile(
        onTap: isMarkingAsRead ? null : onTap,
        leading: CircleAvatar(child: Icon(_icon(notification.type))),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead
                      ? FontWeight.normal
                      : FontWeight.w700,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.content),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(_typeLabel(context, notification.type)),
                ),
                if (date != null)
                  Text(
                    DateFormat.yMMMd(locale).add_Hm().format(date.toLocal()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ],
        ),
        trailing: isMarkingAsRead
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                notification.isRead ? Icons.done_all : Icons.mark_email_unread,
              ),
      ),
    );
  }
}

IconData _icon(AppNotificationType type) => switch (type) {
  AppNotificationType.borrow ||
  AppNotificationType.returnBook ||
  AppNotificationType.dueSoon ||
  AppNotificationType.overdue => Icons.library_books_outlined,
  AppNotificationType.fine ||
  AppNotificationType.payment => Icons.payments_outlined,
  AppNotificationType.system ||
  AppNotificationType.unknown => Icons.notifications_outlined,
};

String _typeLabel(BuildContext context, AppNotificationType type) {
  final l10n = context.l10n;
  return switch (type) {
    AppNotificationType.borrow => l10n.notificationTypeBorrow,
    AppNotificationType.returnBook => l10n.notificationTypeReturn,
    AppNotificationType.dueSoon => l10n.notificationTypeDueSoon,
    AppNotificationType.overdue => l10n.notificationTypeOverdue,
    AppNotificationType.fine => l10n.notificationTypeFine,
    AppNotificationType.payment => l10n.notificationTypePayment,
    AppNotificationType.system => l10n.notificationTypeSystem,
    AppNotificationType.unknown => l10n.notificationTypeUnknown,
  };
}
