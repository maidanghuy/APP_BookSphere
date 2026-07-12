import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:booksphere_app/features/auth/data/auth_api.dart';
import 'package:booksphere_app/features/auth/data/auth_models.dart';

class AuthRepository {
  const AuthRepository(this._authApi, this._secureStorageService);

  final AuthApi _authApi;
  final SecureStorageService _secureStorageService;

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await _authApi.login(
      LoginRequest(username: username, password: password),
    );

    await _secureStorageService.saveAccessToken(response.accessToken);
    await _secureStorageService.saveRefreshToken(response.refreshToken);

    final role = response.role;
    if (role != null && role.isNotEmpty) {
      await _secureStorageService.saveUserRole(role);
    }

    final userId = response.userId;
    if (userId != null && userId.isNotEmpty) {
      await _secureStorageService.saveUserId(userId);
    }

    final responseUsername = response.username;
    if (responseUsername != null && responseUsername.isNotEmpty) {
      await _secureStorageService.saveUsername(responseUsername);
    }

    final responseFullName = response.fullName;
    if (responseFullName != null && responseFullName.isNotEmpty) {
      await _secureStorageService.saveFullName(responseFullName);
    }

    return response;
  }

  Future<RegisterResponse> register({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String password,
  }) {
    return _authApi.register(
      RegisterRequest(
        fullName: fullName,
        username: username,
        email: email,
        phone: phone,
        password: password,
      ),
    );
  }

  Future<bool> logout() async {
    var didReachLogoutApi = true;
    final refreshToken = await _secureStorageService.getRefreshToken();

    try {
      await _authApi.logout(refreshToken: refreshToken);
    } on Object {
      didReachLogoutApi = false;
    } finally {
      await _secureStorageService.clearUserSession();
    }

    return didReachLogoutApi;
  }
}
