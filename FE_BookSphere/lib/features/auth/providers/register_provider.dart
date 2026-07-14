import 'package:booksphere_app/core/constants/app_message_keys.dart';
import 'package:booksphere_app/features/auth/data/auth_models.dart';
import 'package:booksphere_app/features/auth/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerControllerProvider =
    NotifierProvider<RegisterController, RegisterState>(RegisterController.new);

class RegisterState {
  const RegisterState({
    this.isLoading = false,
    this.errorCode,
    this.errorStatusCode,
  });

  final bool isLoading;
  final String? errorCode;
  final int? errorStatusCode;

  RegisterState copyWith({
    bool? isLoading,
    String? errorCode,
    int? errorStatusCode,
    bool clearError = false,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      errorStatusCode: clearError
          ? null
          : errorStatusCode ?? this.errorStatusCode,
    );
  }
}

class RegisterController extends Notifier<RegisterState> {
  @override
  RegisterState build() {
    return const RegisterState();
  }

  Future<bool> register({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (state.isLoading) {
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await ref
          .read(authRepositoryProvider)
          .register(
            fullName: fullName,
            username: username,
            email: email,
            phone: phone,
            password: password,
          );
      state = const RegisterState();
      return true;
    } on AuthRegisterException catch (error) {
      state = RegisterState(
        errorCode: error.code,
        errorStatusCode: error.statusCode,
      );
      return false;
    } on Object {
      state = const RegisterState(errorCode: AppMessageKeys.unknownError);
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
