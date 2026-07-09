# BookSphere Mobile

Tasks:
- BS-APP-01 - Initialize Flutter Project
- BS-APP-02 - Configure Dependencies
- BS-APP-04 - Build Dio Client
- BS-APP-05 - Secure Token Storage
- BS-APP-06 - Splash Screen and Auth Guard
- BS-APP-07 - Login Screen

Coder: maidanghuy

## Versions

- Flutter: 3.44.1 stable
- Dart: 3.12.1 stable

## Tech Stack

- Flutter mobile app
- Dart
- Material 3
- Android support
- iOS scaffold for future expansion
- Runtime dependencies: flutter_riverpod, go_router, dio, flutter_secure_storage, shared_preferences, intl, json_annotation
- Dev dependencies: flutter_lints, build_runner, json_serializable, mocktail

## Dependencies

BS-APP-02 - Cấu hình Dependencies

Coder: maidanghuy

Runtime dependencies:
- flutter_riverpod
- go_router
- dio
- flutter_secure_storage
- shared_preferences
- intl
- json_annotation

Dev dependencies:
- flutter_lints
- build_runner
- json_serializable
- mocktail

## Dio Client

BS-APP-04 - Xây dựng Dio Client

Coder: maidanghuy

- Dio Client uses `AppConfig.apiBaseUrl`.
- The app calls API Gateway only.
- The app must not call internal microservice ports directly.
- Network timeout is configured centrally.
- Request, response, and error interceptors are prepared.
- Bearer token support uses an `AuthTokenProvider` abstraction.
- Secure token storage will be implemented in a later task.
- UI and Auth flow will be implemented in later tasks.

Future usage example only, not implemented business logic:

```dart
final dioClient = DioClient();
final response = await dioClient.get(ApiEndpoints.books);
```

## Secure Token Storage

BS-APP-05 - Secure Token Storage

Coder: maidanghuy

- Tokens are stored with `flutter_secure_storage`.
- Access token and refresh token are not stored in temporary variables.
- Passwords are not stored.
- Tokens are not logged to the console.
- Storage methods support saving, reading, and clearing token data.
- Logout flow will use `clearUserSession()`.
- Login, Register, and Auth flow will be implemented in later tasks.

Future usage example only, not a complete login or logout flow:

```dart
final storage = SecureStorageService();

await storage.saveAccessToken(accessToken);
final token = await storage.getAccessToken();
await storage.clearUserSession();
```

## Splash Screen And Auth Guard

BS-APP-06 - Splash Screen và Auth Guard

Coder: maidanghuy

- App starts at `/splash`.
- Splash checks access token and refresh token.
- Unauthenticated sessions navigate to `/login`.
- Authenticated sessions navigate to `/main`.
- Expired access tokens with a refresh token attempt refresh through API Gateway.
- Refresh failure clears the session and navigates to `/login`.
- Connection errors show a retry state on the splash screen.
- Login Screen is implemented in BS-APP-07.
- Real Main Tab Screen will be implemented in BS-APP-10.

## Login Screen

BS-APP-07 - Login Screen

Coder: maidanghuy

- Login calls `POST /api/auth/login`.
- Login uses username and password.
- Successful login stores access token, refresh token, role, and userId if provided.
- Tokens and session values are stored with `SecureStorageService`.
- Successful login navigates to `/main`.
- Invalid credentials are mapped from `AUTH_INVALID_CREDENTIALS`.
- Inactive accounts are mapped from `AUTH_ACCOUNT_INACTIVE`.
- Register Screen will be implemented in BS-APP-08.
- Logout flow will be implemented in BS-APP-09.
- MainTab will be implemented in BS-APP-10.

## Folder Structure

```text
APP_BookSphere/
|-- android/
|-- ios/
|-- assets/
|   |-- images/
|   |-- icons/
|   `-- fonts/
|-- lib/
|   |-- main.dart
|   |-- app/
|   |   |-- app.dart
|   |   |-- router.dart
|   |   `-- theme.dart
|   |-- core/
|   |   |-- config/
|   |   |   `-- app_config.dart
|   |   |-- constants/
|   |   |   |-- api_endpoints.dart
|   |   |   `-- storage_keys.dart
|   |   |-- network/
|   |   |   |-- api_exception.dart
|   |   |   |-- auth_interceptor.dart
|   |   |   |-- auth_token_provider.dart
|   |   |   |-- dio_client.dart
|   |   |   `-- network_constants.dart
|   |   |-- storage/
|   |   |   |-- secure_auth_token_provider.dart
|   |   |   `-- secure_storage_service.dart
|   |   |-- utils/
|   |   |   `-- jwt_utils.dart
|   |   `-- widgets/
|   |-- shared/
|   |   |-- models/
|   |   |   |-- api_error.dart
|   |   |   `-- api_response.dart
|   |   `-- enums/
|   |-- features/
|   |   |-- auth/
|   |   |   |-- data/
|   |   |   |   |-- auth_api.dart
|   |   |   |   |-- auth_models.dart
|   |   |   |   |-- auth_repository.dart
|   |   |   |   `-- auth_session_service.dart
|   |   |   |-- presentation/
|   |   |   |   |-- login_screen.dart
|   |   |   |   `-- splash_screen.dart
|   |   |   `-- providers/
|   |   |       |-- auth_guard_provider.dart
|   |   |       `-- login_provider.dart
|   |   |-- home/
|   |   |-- books/
|   |   |-- borrows/
|   |   |-- fines/
|   |   |-- notifications/
|   |   `-- profile/
|   `-- generated/
|-- test/
|-- pubspec.yaml
|-- analysis_options.yaml
|-- README.md
|-- README_PRM393_Frontend_Flutter_Implementation_Plan.md
`-- .gitignore
```

## Commands

```bash
flutter pub get
```

```bash
flutter run
```

```bash
flutter build apk
```

Dependency validation:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk
```

## API Base URL

Pass `API_BASE_URL` with `--dart-define`:

```bash
flutter run \
  --dart-define=API_BASE_URL=http://192.168.1.10:8080
```
