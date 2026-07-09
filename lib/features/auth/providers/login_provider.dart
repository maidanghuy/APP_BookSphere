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
  const LoginState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
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
      state = LoginState(errorMessage: error.message);
      return false;
    } on Object {
      state = const LoginState(
        errorMessage: 'Không thể đăng nhập. Vui lòng thử lại.',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
