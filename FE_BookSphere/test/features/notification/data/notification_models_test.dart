import 'package:booksphere_app/features/notification/data/notification_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses notification response fields', () {
    final notification = AppNotification.fromJson({
      'id': 12,
      'title': 'Borrow due soon',
      'content': 'Return the book tomorrow.',
      'type': 'DUE_SOON',
      'referenceId': 44,
      'isRead': false,
      'createdAt': '2026-07-10T08:30:00',
    });

    expect(notification.id, 12);
    expect(notification.type, AppNotificationType.dueSoon);
    expect(notification.referenceId, 44);
    expect(notification.isRead, isFalse);
    expect(notification.createdAt, isNotNull);
  });

  test('maps unsupported notification type to unknown', () {
    expect(parseNotificationType('NEW_TYPE'), AppNotificationType.unknown);
  });
}
