import 'package:booksphere_app/core/constants/app_message_keys.dart';
import 'package:booksphere_app/features/auth/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logoutControllerProvider =
    NotifierProvider<LogoutController, LogoutState>(LogoutController.new);

class LogoutState {
  const LogoutState({this.isLoading = false, this.errorCode});

  final bool isLoading;
  final String? errorCode;

  LogoutState copyWith({
    bool? isLoading,
    String? errorCode,
    bool clearError = false,
  }) {
    return LogoutState(
      isLoading: isLoading ?? this.isLoading,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
    );
  }
}

class LogoutController extends Notifier<LogoutState> {
  @override
  LogoutState build() {
    return const LogoutState();
  }

  Future<bool> logout() async {
    if (state.isLoading) {
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final didReachLogoutApi = await ref.read(authRepositoryProvider).logout();
      state = didReachLogoutApi
          ? const LogoutState()
          : const LogoutState(errorCode: AppMessageKeys.logoutFailed);
      return didReachLogoutApi;
    } on Object {
      state = const LogoutState(errorCode: AppMessageKeys.logoutFailed);
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
