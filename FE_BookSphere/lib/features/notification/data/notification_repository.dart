import 'package:booksphere_app/features/notification/data/notification_api.dart';
import 'package:booksphere_app/features/notification/data/notification_models.dart';

class NotificationRepository {
  const NotificationRepository(this._api);
  final NotificationApi _api;

  Future<List<AppNotification>> getMyNotifications({bool? isRead}) =>
      _api.getMyNotifications(isRead: isRead);

  Future<AppNotification> markAsRead(int id) => _api.markAsRead(id);
}
