import 'dart:convert';

import 'package:booksphere_app/core/utils/jwt_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JwtUtils', () {
    test('reads expiry from a JWT payload', () {
      final token = _tokenWithPayload({'exp': 1893456000});

      expect(JwtUtils.expiryDate(token), DateTime.utc(2030));
    });

    test('treats expired token as expired', () {
      final token = _tokenWithPayload({'exp': 946684800});

      expect(JwtUtils.isExpired(token, now: DateTime.utc(2030)), isTrue);
    });

    test('treats invalid token format as expired', () {
      expect(JwtUtils.expiryDate('invalid-token'), isNull);
      expect(JwtUtils.isExpired('invalid-token'), isTrue);
    });
  });
}

String _tokenWithPayload(Map<String, Object?> payload) {
  final header = _base64UrlJson({'alg': 'none', 'typ': 'JWT'});
  final body = _base64UrlJson(payload);
  return '$header.$body.signature';
}

String _base64UrlJson(Map<String, Object?> value) {
  return base64UrlEncode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
}
