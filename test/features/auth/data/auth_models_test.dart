import 'package:booksphere_app/features/auth/data/auth_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginRequest', () {
    test('serializes username and password only', () {
      const request = LoginRequest(
        username: 'reader',
        password: 'password-value',
      );

      expect(request.toJson(), {
        'username': 'reader',
        'password': 'password-value',
      });
    });
  });

  group('LoginResponse', () {
    test('parses tokens from nested data payload', () {
      final response = LoginResponse.fromJson({
        'success': true,
        'data': {
          'tokens': {
            'accessToken': 'access-value',
            'refreshToken': 'refresh-value',
          },
          'user': {
            'id': 7,
            'role': {'code': 'ADMIN'},
            'username': 'reader',
            'fullName': 'Book Reader',
          },
        },
      });

      expect(response.accessToken, 'access-value');
      expect(response.refreshToken, 'refresh-value');
      expect(response.role, 'ADMIN');
      expect(response.userId, '7');
      expect(response.username, 'reader');
      expect(response.fullName, 'Book Reader');
      expect(response.isValid, isTrue);
    });
  });
}
