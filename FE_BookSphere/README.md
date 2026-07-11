# BookSphere Mobile

Tasks:
- BS-APP-01 - Initialize Flutter Project
- BS-APP-02 - Configure Dependencies
- BS-APP-04 - Build Dio Client
- BS-APP-05 - Secure Token Storage
- BS-APP-06 - Splash Screen and Auth Guard
- BS-APP-07 - Login Screen
- BS-APP-07A - Theme, Localization, Message Constants and API Endpoint Constants
- BS-APP-07B - UI Theme & Language Switcher
- BS-APP-08 - Register Screen
- BS-APP-09 - Logout

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
- Runtime dependencies: flutter_riverpod, go_router, dio, flutter_secure_storage, shared_preferences, intl, flutter_localizations, json_annotation
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
- flutter_localizations
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
- Logout flow uses `clearUserSession()`.
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
- Register Screen is implemented in BS-APP-08.
- Logout flow is implemented in BS-APP-09.
- MainTab will be implemented in BS-APP-10.

## Theme, Localization, Message Constants And API Endpoint Constants

BS-APP-07A - Theme Mode, Localization, Message Constants và API Endpoint Constants

Coder: maidanghuy

- App supports Light Mode, Dark Mode, and System Mode.
- App supports 3 languages:
  - Vietnamese: `vi`
  - English: `en`
  - Japanese: `ja`
- Language is managed centrally with `LocaleProvider`.
- Theme is managed centrally with `ThemeModeProvider`.
- User-facing messages are loaded from ARB localization files.
- Error and message codes are defined in `AppMessageKeys`.
- API endpoints are defined in `ApiEndpoints`.
- Storage keys are defined in `StorageKeys`.
- UI text, user-facing messages, and API paths are not hard-coded across feature files.

## UI Theme And Language Switcher

BS-APP-07B - UI Theme & Language Switcher

Coder: maidanghuy

- Theme and language controls are compact icons in the top-left corner.
- The language action supports Vietnamese (`vi`), English (`en`), and Japanese (`ja`).
- The theme action supports System, Light, and Dark modes.
- The switcher reuses `LocaleProvider`, `ThemeModeProvider`, and existing local storage.
- The switcher is wrapped in `SafeArea` to avoid the status bar and device notch.
- UI labels and tooltips come from localization files and are not hard-coded in screens.

## Register Screen

BS-APP-08 - Register Screen

Coder: maidanghuy

- Register calls `POST /api/auth/register`.
- Register includes full name, username, email, phone, password, and confirm password.
- Registered accounts use the default `MEMBER` role.
- Input validation covers required fields, email format, phone format, password length, and matching confirm password.
- Duplicate username and duplicate email errors are mapped to localized messages.
- Successful registration shows a snackbar and navigates back to `/login`.
- Register does not automatically log in the user.
- Logout flow is implemented in BS-APP-09.
- MainTab will be implemented in BS-APP-10.

## Logout

BS-APP-09 - Logout

Coder: maidanghuy

- Logout calls `POST /api/auth/logout`.
- Logout clears the access token.
- Logout clears the refresh token.
- Logout clears the user role.
- Logout clears the user ID.
- Logout clears local user session state/cache if available.
- After logout, the app navigates to `/login`.
- Logout uses route replacement so users cannot go back to the private placeholder screen.
- If the logout API fails because of network/server issues, the app still clears the local session so the user is logged out from this device.

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
|   |   `-- router.dart
|   |-- core/
|   |   |-- config/
|   |   |   `-- app_config.dart
|   |   |-- constants/
|   |   |   |-- app_constants.dart
|   |   |   |-- app_message_keys.dart
|   |   |   |-- api_endpoints.dart
|   |   |   `-- storage_keys.dart
|   |   |-- localization/
|   |   |   |-- app_locales.dart
|   |   |   |-- l10n_extension.dart
|   |   |   `-- locale_provider.dart
|   |   |-- network/
|   |   |   |-- api_exception.dart
|   |   |   |-- auth_interceptor.dart
|   |   |   |-- auth_token_provider.dart
|   |   |   |-- dio_client.dart
|   |   |   `-- network_constants.dart
|   |   |-- storage/
|   |   |   |-- secure_auth_token_provider.dart
|   |   |   `-- secure_storage_service.dart
|   |   |-- theme/
|   |   |   |-- app_theme.dart
|   |   |   `-- theme_mode_provider.dart
|   |   |-- utils/
|   |   |   |-- error_message_mapper.dart
|   |   |   `-- jwt_utils.dart
|   |   `-- widgets/
|   |       |-- app_top_left_actions.dart
|   |       |-- language_icon_button.dart
|   |       |-- language_selector.dart
|   |       |-- theme_mode_icon_button.dart
|   |       `-- theme_mode_selector.dart
|   |-- l10n/
|   |   |-- app_en.arb
|   |   |-- app_ja.arb
|   |   `-- app_vi.arb
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
|   |   |   |   |-- register_screen.dart
|   |   |   |   |-- widgets/
|   |   |   |   |   `-- logout_button.dart
|   |   |   |   `-- splash_screen.dart
|   |   |   `-- providers/
|   |   |       |-- auth_guard_provider.dart
|   |   |       |-- login_provider.dart
|   |   |       |-- logout_provider.dart
|   |   |       `-- register_provider.dart
|   |   |-- home/
|   |   |-- books/
|   |   |-- borrows/
|   |   |-- fines/
|   |   |-- notifications/
|   |   `-- profile/
|   `-- generated/
|-- test/
|-- l10n.yaml
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
flutter gen-l10n
flutter analyze
flutter test
flutter build apk
```

## BS-APP-10 Main Tab Layout

Coder:
maidanghuy

Implemented:

- MainTabScreen
- Material 3 NavigationBar
- 5 main tabs:
  - Home
  - Categories
  - My Borrow
  - Notifications
  - Profile

Current screens are placeholders.
Business features will be implemented in later tasks.

## BS-APP-11 - Home Screen

Coder: maidanghuy

- Home Screen is the primary screen after login.
- Displays a welcome header.
- Includes a search bar UI.
- Includes featured books, categories, and recommended sections.
- Currently uses local mock data.
- Real book API integration will be implemented in later Book tasks.
- Main Tab Layout is provided by BS-APP-10.

## BS-APP-22 - Notification List Screen

Coder: nguyenminhhuong

- Notification list for the authenticated user
- Read/unread state and unread filter
- Mark notification as read
- Borrow/Fine navigation mapping
- Pull-to-refresh
- Loading, empty, and error states
- English, Vietnamese, and Japanese localization

## API Base URL

Pass `API_BASE_URL` with `--dart-define`:

```bash
flutter run \
  --dart-define=API_BASE_URL=http://192.168.1.10:8080
```

## BS-APP-15 - Borrow Create Screen

Coder: Codex

- Implemented `BorrowCreateScreen` to allow members to request a book loan.
- Decoupled from `BookDetailScreen` by loading book information independently using a `bookId` parameter.
- Validates quantity input (required, positive integer, up to available quantity).
- Features a due date picker that defaults to 14 days from today and enforces future dates.
- Requires confirmation before submission.
- Calls `POST /api/borrows` to initiate the SAGA workflow.
- Gracefully handles business exceptions (`BOOK_OUT_OF_STOCK`, `BOOK_INACTIVE`, `BORROW_SAGA_FAILED`).
- Automatically invalidates/reloads book details on successful borrow creation.

## BS-APP-16 - My Borrow List Screen

Coder: khduong84

- Implemented `MyBorrowListScreen` displaying the current member's borrowing history.
- Pull-to-Refresh to reload list from `GET /api/borrows`.
- Horizontal Filter Chips to filter by Status (`ALL`, `BORROWING`, `OVERDUE`, `RETURNED`, `CANCELLED`).
- Reused resilient JSON models (`BorrowResponse`, `BorrowPageResponse`) to safely parse datetime lists.
- Integrated color-coded `BorrowCard` widgets displaying borrow IDs, dates, quantities, and status badges.
- Configured tap events navigating to `/borrows/:id` placeholder route.
- Handles empty state ("You don't have any borrow records.") and network exceptions gracefully.

## BS-APP-17 - Borrow Detail Screen

Coder: khduong84

- Implemented `BorrowDetailScreen` showing individual borrow session details.
- Loads details using `GET /api/borrows/{borrowId}` mapped through `borrowDetailsProvider`.
- Displays borrow session header: ID, Member Name, Username, status chip, and date logs.
- Displays list of borrow items using `BorrowItemCard` rendering book metadata, quantities, and statuses.
- Overdue warning banner displays when status is `OVERDUE` ("This borrow is overdue.").
- Action return book button displays for `BORROWING`/`OVERDUE` statuses.
- Calls `POST /api/borrows/{borrowId}/return` on confirmed action, showing a loading indicator and reloading the screens on success.
- Handled network errors and empty states gracefully.



