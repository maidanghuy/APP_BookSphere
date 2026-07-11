import 'package:booksphere_app/core/constants/api_endpoints.dart';
import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/features/notification/data/notification_models.dart';

class NotificationApi {
  const NotificationApi(this._client);
  final DioClient _client;

  Future<List<AppNotification>> getMyNotifications({bool? isRead}) async {
    final response = await _client.get<Object?>(
      '${ApiEndpoints.notifications}/my',
      queryParameters: {
        'isRead': ?isRead,
        'page': 0,
        'size': 100,
        'sortBy': 'createdAt',
        'sortDir': 'desc',
      },
    );
    final root = _asMap(response.data);
    final page = _asMap(root['data']);
    final content = page['content'];
    if (content is! List) return const [];
    return content
        .whereType<Map>()
        .map(
          (item) => AppNotification.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  Future<AppNotification> markAsRead(int id) async {
    final response = await _client.put<Object?>(
      '${ApiEndpoints.notifications}/$id/read',
    );
    return AppNotification.fromJson(_asMap(_asMap(response.data)['data']));
  }

  Map<String, dynamic> _asMap(Object? value) => value is Map
      ? Map<String, dynamic>.from(value)
      : const <String, dynamic>{};
}
