import 'dart:convert';

class JwtUtils {
  const JwtUtils._();

  static DateTime? expiryDate(String token) {
    final payload = _decodePayload(token);
    if (payload == null) {
      return null;
    }

    final exp = payload['exp'];
    final seconds = switch (exp) {
      int value => value,
      num value => value.toInt(),
      String value => int.tryParse(value),
      _ => null,
    };

    if (seconds == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
  }

  static bool isExpired(String token, {DateTime? now}) {
    final expiry = expiryDate(token);
    if (expiry == null) {
      return true;
    }

    return !expiry.isAfter(now?.toUtc() ?? DateTime.now().toUtc());
  }

  static Map<String, dynamic>? _decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }

    try {
      final normalizedPayload = base64Url.normalize(parts[1]);
      final payloadJson = utf8.decode(base64Url.decode(normalizedPayload));
      final payload = jsonDecode(payloadJson);
      if (payload is Map<String, dynamic>) {
        return payload;
      }
      if (payload is Map) {
        return Map<String, dynamic>.from(payload);
      }
    } on Object {
      return null;
    }

    return null;
  }
}
