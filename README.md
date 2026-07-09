# BookSphere Mobile

Tasks:
- BS-APP-01 - Initialize Flutter Project
- BS-APP-02 - Configure Dependencies

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
|   |   |-- network/
|   |   |-- storage/
|   |   |-- utils/
|   |   `-- widgets/
|   |-- shared/
|   |   |-- models/
|   |   `-- enums/
|   |-- features/
|   |   |-- auth/
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
