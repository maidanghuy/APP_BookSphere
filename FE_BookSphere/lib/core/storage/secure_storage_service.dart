import 'package:booksphere_app/core/constants/storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? _defaultStorage;

  static const FlutterSecureStorage _defaultStorage = FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> saveAccessToken(String token) {
    return _write(StorageKeys.accessToken, token);
  }

  Future<String?> getAccessToken() {
    return _read(StorageKeys.accessToken);
  }

  Future<void> saveRefreshToken(String token) {
    return _write(StorageKeys.refreshToken, token);
  }

  Future<String?> getRefreshToken() {
    return _read(StorageKeys.refreshToken);
  }

  Future<void> saveUserRole(String role) {
    return _write(StorageKeys.userRole, role);
  }

  Future<String?> getUserRole() {
    return _read(StorageKeys.userRole);
  }

  Future<void> saveUserId(String userId) {
    return _write(StorageKeys.userId, userId);
  }

  Future<String?> getUserId() {
    return _read(StorageKeys.userId);
  }

  Future<void> saveUsername(String username) {
    return _write(StorageKeys.username, username);
  }

  Future<String?> getUsername() {
    return _read(StorageKeys.username);
  }

  Future<void> saveFullName(String fullName) {
    return _write(StorageKeys.fullName, fullName);
  }

  Future<String?> getFullName() {
    return _read(StorageKeys.fullName);
  }

  Future<void> clearAccessToken() {
    return _delete(StorageKeys.accessToken);
  }

  Future<void> clearRefreshToken() {
    return _delete(StorageKeys.refreshToken);
  }

  Future<void> clearUserSession() async {
    await Future.wait([
      clearAccessToken(),
      clearRefreshToken(),
      _delete(StorageKeys.userRole),
      _delete(StorageKeys.userId),
    ]);
  }

  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<bool> hasRefreshToken() async {
    final token = await getRefreshToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> _write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } on Object catch (error) {
      throw SecureStorageException(
        message: 'Unable to save secure session value.',
        rawError: error,
      );
    }
  }

  Future<String?> _read(String key) async {
    try {
      return _storage.read(key: key);
    } on Object catch (error) {
      throw SecureStorageException(
        message: 'Unable to read secure session value.',
        rawError: error,
      );
    }
  }

  Future<void> _delete(String key) async {
    try {
      await _storage.delete(key: key);
    } on Object catch (error) {
      throw SecureStorageException(
        message: 'Unable to clear secure session value.',
        rawError: error,
      );
    }
  }
}

class SecureStorageException implements Exception {
  const SecureStorageException({required this.message, this.rawError});

  final String message;
  final Object? rawError;

  @override
  String toString() {
    return 'SecureStorageException(message: $message)';
  }
}
