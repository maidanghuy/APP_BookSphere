class NetworkConstants {
  const NetworkConstants._();

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);

  static const String acceptHeader = 'Accept';
  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'Authorization';
  static const String applicationJson = 'application/json';
  static const String bearerPrefix = 'Bearer';

  static const List<String> authBypassPathSegments = [
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
  ];
}
