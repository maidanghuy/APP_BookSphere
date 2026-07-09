# BookSphere Mobile

Task: BS-APP-01 - Initialize Flutter Project

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
- Dependencies declared for future tasks: flutter_riverpod, dio, go_router, flutter_secure_storage, shared_preferences, intl, json_annotation, json_serializable, build_runner

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

## API Base URL

Pass `API_BASE_URL` with `--dart-define`:

```bash
flutter run \
  --dart-define=API_BASE_URL=http://192.168.1.10:8080
```
