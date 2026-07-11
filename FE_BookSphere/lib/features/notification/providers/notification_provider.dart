import 'package:booksphere_app/core/constants/app_message_keys.dart';
import 'package:booksphere_app/core/network/api_exception.dart';
import 'package:booksphere_app/core/network/dio_client.dart';
import 'package:booksphere_app/core/storage/secure_auth_token_provider.dart';
import 'package:booksphere_app/features/auth/providers/auth_guard_provider.dart';
import 'package:booksphere_app/features/notification/data/notification_api.dart';
import 'package:booksphere_app/features/notification/data/notification_models.dart';
import 'package:booksphere_app/features/notification/data/notification_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  final client = DioClient(authTokenProvider: SecureAuthTokenProvider(storage));
  return NotificationRepository(NotificationApi(client));
});

final notificationControllerProvider =
    NotifierProvider<NotificationController, NotificationState>(
      NotificationController.new,
    );

class NotificationState {
  const NotificationState({
    this.isLoading = true,
    this.isRefreshing = false,
    this.notifications = const [],
    this.showUnreadOnly = false,
    this.markingAsReadIds = const {},
    this.errorCode,
  });

  final bool isLoading;
  final bool isRefreshing;
  final List<AppNotification> notifications;
  final bool showUnreadOnly;
  final Set<int> markingAsReadIds;
  final String? errorCode;

  List<AppNotification> get visibleNotifications => showUnreadOnly
      ? notifications.where((item) => !item.isRead).toList()
      : notifications;

  int get unreadCount => notifications.where((item) => !item.isRead).length;

  NotificationState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    List<AppNotification>? notifications,
    bool? showUnreadOnly,
    Set<int>? markingAsReadIds,
    String? errorCode,
    bool clearError = false,
  }) => NotificationState(
    isLoading: isLoading ?? this.isLoading,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    notifications: notifications ?? this.notifications,
    showUnreadOnly: showUnreadOnly ?? this.showUnreadOnly,
    markingAsReadIds: markingAsReadIds ?? this.markingAsReadIds,
    errorCode: clearError ? null : errorCode ?? this.errorCode,
  );
}

class NotificationController extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    Future.microtask(load);
    return const NotificationState();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _fetch(isRefresh: false);
  }

  Future<void> refresh() => _fetch(isRefresh: true);

  Future<void> _fetch({required bool isRefresh}) async {
    if (isRefresh) state = state.copyWith(isRefreshing: true, clearError: true);
    try {
      final items = await ref
          .read(notificationRepositoryProvider)
          .getMyNotifications();
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        notifications: items,
        clearError: true,
      );
    } on DioException catch (error) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorCode: _errorCode(error),
      );
    }
  }

  void setUnreadOnly(bool value) =>
      state = state.copyWith(showUnreadOnly: value);

  Future<bool> markAsRead(int id) async {
    final item = state.notifications.where((item) => item.id == id).firstOrNull;
    if (item == null || item.isRead || state.markingAsReadIds.contains(id)) {
      return true;
    }
    state = state.copyWith(markingAsReadIds: {...state.markingAsReadIds, id});
    try {
      final updated = await ref
          .read(notificationRepositoryProvider)
          .markAsRead(id);
      state = state.copyWith(
        notifications: [
          for (final notification in state.notifications)
            if (notification.id == id) updated else notification,
        ],
        markingAsReadIds: {...state.markingAsReadIds}..remove(id),
      );
      return true;
    } on DioException {
      state = state.copyWith(
        markingAsReadIds: {...state.markingAsReadIds}..remove(id),
      );
      return false;
    }
  }

  String _errorCode(DioException error) {
    final api = ApiException.fromDioException(error);
    if (api.statusCode == 500 || api.statusCode == 503) {
      return AppMessageKeys.serverUnavailable;
    }
    if (error.response == null) return AppMessageKeys.networkError;
    return AppMessageKeys.unknownError;
  }
}
