import 'package:booksphere_app/core/constants/app_constants.dart';

class AppConfig {
  static const appName = AppConstants.appName;

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
}
