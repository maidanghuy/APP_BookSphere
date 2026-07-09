[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/yx8Hj6pC)

# BookSphere

BookSphere is a Spring Cloud microservices and Flutter mobile application project for the MSS301 distributed library management system.

The system contains:

- `BE_BookSphere`: Spring Cloud Microservices Backend
- `FE_BookSphere`: Flutter Mobile App / Flutter Web

## Project Structure

```text
BookSphere/
|-- BE_BookSphere/
|   |-- api-gateway/
|   |-- discovery-server/
|   |-- config-server/
|   |-- auth-service/
|   |-- book-service/
|   |-- borrow-service/
|   |-- fine-service/
|   |-- notification-service/
|   |-- infrastructure/
|   |-- postman/
|   `-- docker-compose.yml
`-- FE_BookSphere/
    |-- android/
    |-- ios/
    |-- lib/
    |-- test/
    `-- pubspec.yaml
```

## Backend Services

| Service | Port | Database |
| --- | ---: | --- |
| api-gateway | 8080 | - |
| discovery-server | 8761 | - |
| config-server | 8888 | - |
| auth-service | 8081 | DBAuth |
| book-service | 8082 | DBBook |
| borrow-service | 8083 | DBBorrow |
| fine-service | 8084 | DBFine |
| notification-service | 8085 | DBNotification |

> Client apps must call Backend through API Gateway only: `http://localhost:8080` or `http://<YOUR_IP>:8080`.
> App and Web must not call internal service ports `8081` to `8085` directly.

## Run Backend

Go to the Backend folder:

```bash
cd BE_BookSphere
```

Copy the environment file:

```bash
cp .env.example .env
```

Run the full local stack with Docker Compose:

```bash
docker compose up -d --build
```

API Gateway:

```text
http://localhost:8080
```

For normal restarts after images have already been built:

```bash
docker compose up -d
```

If the stack is only stopped and no code changed:

```bash
docker compose stop
docker compose start
```

When changing code in one service, rebuild only that service:

```bash
docker compose up -d --build api-gateway
docker compose up -d --build borrow-service
```

Start only infrastructure containers and run Spring Boot services manually:

```bash
docker compose up -d mysql redis zipkin
```

Useful Docker Compose commands:

```bash
docker compose ps
docker compose logs -f api-gateway
docker compose down
```

## Build Backend Services

Each service is an independent Maven project using Java 21 and Spring Boot 3.x.

```bash
cd BE_BookSphere/discovery-server && mvn clean package -DskipTests
cd ../config-server && mvn clean package -DskipTests
cd ../api-gateway && mvn clean package -DskipTests
cd ../auth-service && mvn clean package -DskipTests
cd ../book-service && mvn clean package -DskipTests
cd ../borrow-service && mvn clean package -DskipTests
cd ../fine-service && mvn clean package -DskipTests
cd ../notification-service && mvn clean package -DskipTests
```

## Run Flutter App On Android Phone

First, make sure Backend is running.

The Android phone and the computer running Backend must be connected to the same Wi-Fi.

### Get Computer IP On MacBook

```bash
ipconfig getifaddr en0
```

Example:

```text
192.168.1.25
```

### Get Computer IP On Windows

```bash
ipconfig
```

Find:

```text
IPv4 Address: 192.168.1.25
```

### Run Flutter App

Go to the Flutter project:

```bash
cd FE_BookSphere
```

Install Flutter dependencies:

```bash
flutter pub get
```

Run the app with the API Gateway URL using the computer IP:

```bash
flutter run --dart-define=API_BASE_URL=http://<IP>:8080
```

Example:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.25:8080
```

Do not use `localhost` when running on a real Android phone.

Use:

```text
http://<YOUR_COMPUTER_IP>:8080
```

Instead of:

```text
http://localhost:8080
```

`localhost` on the phone means the phone itself, not the computer running Backend.

## Run Flutter Web

Go to the Flutter project:

```bash
cd FE_BookSphere
```

Enable web if needed:

```bash
flutter create --platforms=web .
```

Run on Chrome:

```bash
flutter run -d chrome
```

Run on Chrome with API Gateway URL:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080
```

When running Flutter Web on the same computer as Backend, `http://localhost:8080` can be used.

When running on a real Android phone, use the computer IP, such as `http://192.168.1.25:8080`.

## Common Notes

- Backend API Gateway runs on port `8080`.
- Internal services run on ports `8081` to `8085`.
- Frontend must not call internal service ports directly.
- Use `API_BASE_URL=http://<IP>:8080` for real Android devices.
- Use `API_BASE_URL=http://localhost:8080` for Flutter Web on the same computer.
- If the Android phone cannot call API Gateway, check that the phone and computer are on the same Wi-Fi.
- If Docker services fail to start, check container status with `docker compose ps`.
- If Backend code changes, rebuild the changed service image before testing again.
