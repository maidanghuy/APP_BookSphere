class LoginRequest {
  const LoginRequest({required this.username, required this.password});

  final String username;
  final String password;

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

class LoginResponse {
  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    this.role,
    this.userId,
    this.username,
    this.fullName,
  });

  final String accessToken;
  final String refreshToken;
  final String? role;
  final String? userId;
  final String? username;
  final String? fullName;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final payload = _asMap(json['data']) ?? json;
    final tokenPayload =
        _asMap(payload['tokens']) ?? _asMap(payload['token']) ?? payload;
    final userPayload =
        _asMap(payload['user']) ??
        _asMap(payload['account']) ??
        _asMap(payload['profile']);

    return LoginResponse(
      accessToken:
          _firstString([
            payload['accessToken'],
            payload['access_token'],
            tokenPayload['accessToken'],
            tokenPayload['access_token'],
          ]) ??
          '',
      refreshToken:
          _firstString([
            payload['refreshToken'],
            payload['refresh_token'],
            tokenPayload['refreshToken'],
            tokenPayload['refresh_token'],
          ]) ??
          '',
      role: _firstString([
        payload['role'],
        payload['roleName'],
        userPayload?['role'],
        userPayload?['roleName'],
      ]),
      userId: _firstString([
        payload['userId'],
        payload['user_id'],
        payload['id'],
        userPayload?['userId'],
        userPayload?['user_id'],
        userPayload?['id'],
      ]),
      username: _firstString([
        payload['username'],
        userPayload?['username'],
        userPayload?['email'],
      ]),
      fullName: _firstString([
        payload['fullName'],
        payload['full_name'],
        payload['name'],
        userPayload?['fullName'],
        userPayload?['full_name'],
        userPayload?['name'],
      ]),
    );
  }

  bool get isValid {
    return accessToken.isNotEmpty && refreshToken.isNotEmpty;
  }
}

class AuthLoginException implements Exception {
  const AuthLoginException({this.code, this.statusCode});

  final String? code;
  final int? statusCode;

  @override
  String toString() {
    return 'AuthLoginException(code: $code, statusCode: $statusCode)';
  }
}

class RegisterRequest {
  const RegisterRequest({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    this.role = 'MEMBER',
  });

  final String fullName;
  final String username;
  final String email;
  final String phone;
  final String password;
  final String role;

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
    };
  }
}

class RegisterResponse {
  const RegisterResponse({
    this.userId,
    this.username,
    this.email,
    this.message = '',
  });

  final String? userId;
  final String? username;
  final String? email;
  final String message;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    final payload = _asMap(json['data']) ?? json;

    return RegisterResponse(
      userId: _firstString([
        payload['userId'],
        payload['user_id'],
        payload['id'],
      ]),
      username: _firstString([payload['username']]),
      email: _firstString([payload['email']]),
      message: _firstString([json['message'], payload['message']]) ?? '',
    );
  }
}

class AuthRegisterException implements Exception {
  const AuthRegisterException({this.code, this.statusCode});

  final String? code;
  final int? statusCode;

  @override
  String toString() {
    return 'AuthRegisterException(code: $code, statusCode: $statusCode)';
  }
}

Map<String, dynamic>? _asMap(Object? value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return null;
}

String? _firstString(Iterable<Object?> values) {
  for (final value in values) {
    final stringValue = _stringValue(value);
    if (stringValue != null && stringValue.isNotEmpty) {
      return stringValue;
    }
  }

  return null;
}

String? _stringValue(Object? value) {
  if (value == null) {
    return null;
  }

  if (value is Map) {
    return _firstString([
      value['code'],
      value['name'],
      value['role'],
      value['id'],
    ]);
  }

  return value.toString().trim();
}
