import 'package:booksphere_app/core/constants/app_message_keys.dart';
import 'package:booksphere_app/features/auth/data/auth_api.dart';
import 'package:booksphere_app/features/auth/data/auth_models.dart';
import 'package:booksphere_app/features/auth/data/auth_repository.dart';
import 'package:booksphere_app/features/auth/providers/auth_guard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(dioClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(authApiProvider),
    ref.watch(secureStorageServiceProvider),
  );
});

final loginControllerProvider = NotifierProvider<LoginController, LoginState>(
  LoginController.new,
);

class LoginState {
  const LoginState({
    this.isLoading = false,
    this.errorCode,
    this.errorStatusCode,
  });

  final bool isLoading;
  final String? errorCode;
  final int? errorStatusCode;

  LoginState copyWith({
    bool? isLoading,
    String? errorCode,
    int? errorStatusCode,
    bool clearError = false,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorStatusCode: clearError
          ? null
          : errorStatusCode ?? this.errorStatusCode,
    );
  }
}

class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    if (state.isLoading) {
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await ref
          .read(authRepositoryProvider)
          .login(username: username, password: password);
      state = const LoginState();
      return true;
    } on AuthLoginException catch (error) {
      state = LoginState(
        errorCode: error.code,
        errorStatusCode: error.statusCode,
      );
      return false;
    } on Object {
      state = const LoginState(errorCode: AppMessageKeys.unknownError);
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
