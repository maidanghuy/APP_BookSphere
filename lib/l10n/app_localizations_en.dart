// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'BookSphere';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get login => 'Login';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get checkingSession => 'Checking session...';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get lightMode => 'Light';

  @override
  String get darkMode => 'Dark';

  @override
  String get systemMode => 'System';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get japanese => 'Japanese';

  @override
  String get invalidCredentials => 'The username or password is incorrect.';

  @override
  String get accountInactive =>
      'The account is locked or has not been activated.';

  @override
  String get networkError =>
      'Unable to connect to the server. Please check your network or API Gateway.';

  @override
  String get serverUnavailable =>
      'The system is temporarily unavailable. Please try again later.';

  @override
  String get unknownError => 'An unknown error occurred. Please try again.';

  @override
  String get retry => 'Try again';

  @override
  String get mainScreenPlaceholder =>
      'Main screen will be implemented in BS-APP-10';

  @override
  String get registerScreenPlaceholder =>
      'Register screen will be implemented in BS-APP-08';

  @override
  String get usernameRequired => 'Please enter your username.';

  @override
  String get passwordRequired => 'Please enter your password.';

  @override
  String get loginFailed => 'Unable to log in. Please try again.';
}
