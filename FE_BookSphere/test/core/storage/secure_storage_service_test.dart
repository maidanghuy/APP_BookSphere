import 'package:booksphere_app/core/storage/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SecureStorageService', () {
    late SecureStorageService storageService;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      storageService = SecureStorageService();
    });

    test('saves and reads access token', () async {
      await storageService.saveAccessToken('sample-access-value');

      expect(await storageService.getAccessToken(), 'sample-access-value');
      expect(await storageService.hasAccessToken(), isTrue);
    });

    test('saves and reads refresh token', () async {
      await storageService.saveRefreshToken('sample-refresh-value');

      expect(await storageService.getRefreshToken(), 'sample-refresh-value');
      expect(await storageService.hasRefreshToken(), isTrue);
    });

    test('saves and reads user metadata', () async {
      await storageService.saveUserRole('LIBRARIAN');
      await storageService.saveUserId('user-1');

      expect(await storageService.getUserRole(), 'LIBRARIAN');
      expect(await storageService.getUserId(), 'user-1');
    });

    test('clears access and refresh tokens individually', () async {
      await storageService.saveAccessToken('sample-access-value');
      await storageService.saveRefreshToken('sample-refresh-value');

      await storageService.clearAccessToken();
      await storageService.clearRefreshToken();

      expect(await storageService.getAccessToken(), isNull);
      expect(await storageService.getRefreshToken(), isNull);
      expect(await storageService.hasAccessToken(), isFalse);
      expect(await storageService.hasRefreshToken(), isFalse);
    });

    test('clears the full user session', () async {
      await storageService.saveAccessToken('sample-access-value');
      await storageService.saveRefreshToken('sample-refresh-value');
      await storageService.saveUserRole('MEMBER');
      await storageService.saveUserId('user-2');

      await storageService.clearUserSession();

      expect(await storageService.getAccessToken(), isNull);
      expect(await storageService.getRefreshToken(), isNull);
      expect(await storageService.getUserRole(), isNull);
      expect(await storageService.getUserId(), isNull);
    });
  });
}
