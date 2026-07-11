class AppMessageKeys {
  const AppMessageKeys._();

  static const String authInvalidCredentials = 'AUTH_INVALID_CREDENTIALS';
  static const String authAccountInactive = 'AUTH_ACCOUNT_INACTIVE';
  static const String authTokenExpired = 'AUTH_TOKEN_EXPIRED';
  static const String authRefreshTokenInvalid = 'AUTH_REFRESH_TOKEN_INVALID';
  static const String authLoginInvalidResponse = 'AUTH_LOGIN_INVALID_RESPONSE';
  static const String authRegisterInvalidResponse =
      'AUTH_REGISTER_INVALID_RESPONSE';
  static const String authUsernameDuplicated = 'AUTH_USERNAME_DUPLICATED';
  static const String authEmailDuplicated = 'AUTH_EMAIL_DUPLICATED';
  static const String usernameAlreadyExists = 'USERNAME_ALREADY_EXISTS';
  static const String emailAlreadyExists = 'EMAIL_ALREADY_EXISTS';
  static const String invalidRegistrationData = 'INVALID_REGISTRATION_DATA';
  static const String registrationConflict = 'REGISTRATION_CONFLICT';
  static const String logoutFailed = 'LOGOUT_FAILED';

  static const String networkError = 'NETWORK_ERROR';
  static const String serverUnavailable = 'SERVER_UNAVAILABLE';
  static const String unknownError = 'UNKNOWN_ERROR';

  static const String bookOutOfStock = 'BOOK_OUT_OF_STOCK';
  static const String bookInactive = 'BOOK_INACTIVE';
  static const String borrowSagaFailed = 'BORROW_SAGA_FAILED';
}
