# BS-APP – Flutter Mobile App Implementation Plan

## 1. Tổng quan Mobile App

Mobile App của hệ thống **BookSphere** được xây dựng bằng **Flutter** nhằm cung cấp trải nghiệm sử dụng nhanh, thuận tiện trên thiết bị di động.

Hệ thống BookSphere có cả:

* **Website ReactJS**: ưu tiên cho `ADMIN` và `LIBRARIAN` để quản lý nghiệp vụ đầy đủ.
* **Mobile App Flutter**: ưu tiên cho `MEMBER` để xem sách, mượn sách, theo dõi phiếu mượn, trả sách, xem tiền phạt, thanh toán tiền phạt và nhận thông báo.

Mobile App không gọi trực tiếp từng microservice nội bộ. Toàn bộ request từ App phải đi qua **API Gateway**.

```txt
Flutter App
    → API Gateway
        → Auth Service
        → Book Service
        → Borrow Service
        → Fine Service
        → Notification Service
```

---

## 2. Mục tiêu của Flutter App

Flutter App cần đáp ứng các mục tiêu sau:

* Người dùng có thể đăng ký, đăng nhập và đăng xuất.
* Người dùng có thể xem danh sách sách.
* Người dùng có thể tìm kiếm và lọc sách.
* Người dùng có thể xem chi tiết sách.
* Người dùng có thể tạo phiếu mượn sách.
* Người dùng có thể xem danh sách phiếu mượn của mình.
* Người dùng có thể trả sách.
* Người dùng có thể xem tiền phạt.
* Người dùng có thể thanh toán tiền phạt.
* Người dùng có thể xem notification.
* Người dùng có thể đánh dấu notification đã đọc.
* App có giao diện mobile thân thiện, dễ sử dụng.
* App có xử lý loading, empty state, error state và offline cơ bản.

---

## 3. Phạm vi chức năng giữa Website và Mobile App

| Chức năng                  | Website ReactJS | Flutter Mobile App |
| -------------------------- | --------------- | ------------------ |
| Đăng nhập / đăng ký        | Có              | Có                 |
| Quản lý sách               | Có đầy đủ       | Chỉ xem sách       |
| Quản lý category           | Có đầy đủ       | Chỉ xem/lọc        |
| Tạo phiếu mượn             | Có thể có       | Có                 |
| Xem phiếu mượn cá nhân     | Có              | Có                 |
| Quản lý toàn bộ phiếu mượn | Có              | Không ưu tiên      |
| Trả sách                   | Có              | Có                 |
| Quản lý tiền phạt          | Có              | Không ưu tiên      |
| Xem tiền phạt cá nhân      | Có              | Có                 |
| Thanh toán tiền phạt       | Có              | Có                 |
| Xem notification           | Có              | Có                 |
| Dashboard quản trị         | Có              | Không ưu tiên      |
| Quản trị hệ thống          | Có              | Không làm trên App |

---

## 4. Công nghệ sử dụng

| Nhóm                 | Công nghệ                              |
| -------------------- | -------------------------------------- |
| Framework            | Flutter                                |
| Language             | Dart                                   |
| State Management     | Riverpod hoặc Bloc                     |
| Routing              | go_router                              |
| HTTP Client          | Dio                                    |
| Secure Token Storage | flutter_secure_storage                 |
| Local Cache          | Hive hoặc SharedPreferences            |
| Model Serialization  | json_serializable + build_runner       |
| Form Validation      | Form + TextFormField Validator         |
| UI                   | Material 3                             |
| Date Format          | intl                                   |
| Loading / Toast      | flutter_easyloading hoặc custom widget |
| Testing              | flutter_test + mocktail                |
| Build Android        | APK / AAB                              |
| Build iOS            | IPA nếu có Mac/Xcode                   |

---

## 5. Biến môi trường App

App cần cấu hình API Gateway URL theo từng môi trường.

```txt
Development:
API_BASE_URL=http://localhost:8080

Android Emulator:
API_BASE_URL=http://10.0.2.2:8080

Real Android Device cùng Wi-Fi:
API_BASE_URL=http://<IP_MAY_CHAY_BE>:8080

Production:
API_BASE_URL=https://api.booksphere.com
```

Gợi ý dùng file config:

```txt
lib/core/config/app_config.dart
```

Ví dụ:

```dart
class AppConfig {
  static const String appName = 'BookSphere';
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
}
```

Chạy app với base URL:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8080
```

---

## 6. Cấu trúc thư mục Flutter đề xuất

```txt
booksphere_app/
├── pubspec.yaml
├── README.md
│
├── android/
├── ios/
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
│
└── lib/
    ├── main.dart
    │
    ├── app/
    │   ├── app.dart
    │   ├── router.dart
    │   └── theme.dart
    │
    ├── core/
    │   ├── config/
    │   │   └── app_config.dart
    │   ├── constants/
    │   │   ├── app_constants.dart
    │   │   ├── api_endpoints.dart
    │   │   └── storage_keys.dart
    │   ├── network/
    │   │   ├── dio_client.dart
    │   │   ├── auth_interceptor.dart
    │   │   └── api_exception.dart
    │   ├── storage/
    │   │   ├── secure_storage_service.dart
    │   │   └── local_cache_service.dart
    │   ├── utils/
    │   │   ├── date_utils.dart
    │   │   ├── currency_utils.dart
    │   │   └── error_mapper.dart
    │   └── widgets/
    │       ├── app_button.dart
    │       ├── app_text_field.dart
    │       ├── app_loading.dart
    │       ├── app_empty_state.dart
    │       ├── app_error_view.dart
    │       ├── app_status_chip.dart
    │       └── confirm_dialog.dart
    │
    ├── shared/
    │   ├── models/
    │   │   ├── api_response.dart
    │   │   ├── api_error.dart
    │   │   └── pagination.dart
    │   └── enums/
    │       ├── user_role.dart
    │       ├── borrow_status.dart
    │       ├── fine_status.dart
    │       └── notification_type.dart
    │
    ├── features/
    │   ├── auth/
    │   │   ├── data/
    │   │   │   ├── auth_api.dart
    │   │   │   ├── auth_repository.dart
    │   │   │   └── auth_models.dart
    │   │   ├── providers/
    │   │   │   └── auth_provider.dart
    │   │   └── presentation/
    │   │       ├── login_screen.dart
    │   │       ├── register_screen.dart
    │   │       └── splash_screen.dart
    │   │
    │   ├── home/
    │   │   └── presentation/
    │   │       ├── home_screen.dart
    │   │       └── main_tab_screen.dart
    │   │
    │   ├── books/
    │   │   ├── data/
    │   │   │   ├── book_api.dart
    │   │   │   ├── book_repository.dart
    │   │   │   └── book_models.dart
    │   │   ├── providers/
    │   │   │   └── book_provider.dart
    │   │   └── presentation/
    │   │       ├── book_list_screen.dart
    │   │       ├── book_detail_screen.dart
    │   │       ├── book_search_screen.dart
    │   │       └── widgets/
    │   │           ├── book_card.dart
    │   │           ├── book_filter_sheet.dart
    │   │           └── book_quantity_badge.dart
    │   │
    │   ├── borrows/
    │   │   ├── data/
    │   │   │   ├── borrow_api.dart
    │   │   │   ├── borrow_repository.dart
    │   │   │   └── borrow_models.dart
    │   │   ├── providers/
    │   │   │   └── borrow_provider.dart
    │   │   └── presentation/
    │   │       ├── borrow_create_screen.dart
    │   │       ├── my_borrow_list_screen.dart
    │   │       ├── borrow_detail_screen.dart
    │   │       └── widgets/
    │   │           ├── borrow_card.dart
    │   │           └── borrow_status_chip.dart
    │   │
    │   ├── fines/
    │   │   ├── data/
    │   │   │   ├── fine_api.dart
    │   │   │   ├── fine_repository.dart
    │   │   │   └── fine_models.dart
    │   │   ├── providers/
    │   │   │   └── fine_provider.dart
    │   │   └── presentation/
    │   │       ├── my_fine_list_screen.dart
    │   │       ├── fine_detail_screen.dart
    │   │       ├── fine_payment_screen.dart
    │   │       └── widgets/
    │   │           ├── fine_card.dart
    │   │           └── payment_method_sheet.dart
    │   │
    │   ├── notifications/
    │   │   ├── data/
    │   │   │   ├── notification_api.dart
    │   │   │   ├── notification_repository.dart
    │   │   │   └── notification_models.dart
    │   │   ├── providers/
    │   │   │   └── notification_provider.dart
    │   │   └── presentation/
    │   │       ├── notification_list_screen.dart
    │   │       └── widgets/
    │   │           ├── notification_tile.dart
    │   │           └── notification_badge.dart
    │   │
    │   └── profile/
    │       ├── providers/
    │       │   └── profile_provider.dart
    │       └── presentation/
    │           ├── profile_screen.dart
    │           └── settings_screen.dart
    │
    └── generated/
```

---

## 7. Màn hình chính của App

| Screen                 | Route             | Role   | Mô tả                        |
| ---------------------- | ----------------- | ------ | ---------------------------- |
| SplashScreen           | `/splash`         | Public | Kiểm tra token và điều hướng |
| LoginScreen            | `/login`          | Public | Đăng nhập                    |
| RegisterScreen         | `/register`       | Public | Đăng ký                      |
| MainTabScreen          | `/main`           | MEMBER | Màn hình chính sau login     |
| HomeScreen             | `/home`           | MEMBER | Trang tổng quan cá nhân      |
| BookListScreen         | `/books`          | MEMBER | Danh sách sách               |
| BookSearchScreen       | `/books/search`   | MEMBER | Tìm kiếm sách                |
| BookDetailScreen       | `/books/:id`      | MEMBER | Chi tiết sách                |
| BorrowCreateScreen     | `/borrows/create` | MEMBER | Tạo phiếu mượn               |
| MyBorrowListScreen     | `/my-borrows`     | MEMBER | Phiếu mượn của tôi           |
| BorrowDetailScreen     | `/borrows/:id`    | MEMBER | Chi tiết phiếu mượn          |
| MyFineListScreen       | `/my-fines`       | MEMBER | Tiền phạt của tôi            |
| FineDetailScreen       | `/fines/:id`      | MEMBER | Chi tiết tiền phạt           |
| FinePaymentScreen      | `/fines/:id/pay`  | MEMBER | Thanh toán tiền phạt         |
| NotificationListScreen | `/notifications`  | MEMBER | Danh sách thông báo          |
| ProfileScreen          | `/profile`        | MEMBER | Thông tin cá nhân            |
| SettingsScreen         | `/settings`       | MEMBER | Cài đặt app                  |

---

## 8. Bottom Navigation đề xuất

App nên có 5 tab chính:

| Tab     | Icon       | Màn hình      |
| ------- | ---------- | ------------- |
| Home    | Home       | `/home`       |
| Books   | Menu book  | `/books`      |
| Borrows | Assignment | `/my-borrows` |
| Fines   | Payments   | `/my-fines`   |
| Profile | Person     | `/profile`    |

Notification có thể đặt ở icon trên AppBar hoặc trong Profile.

---

## 9. Quy ước Model API Response

Flutter App cần map response chuẩn từ Backend.

```dart
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<ApiError>? errors;
  final String timestamp;
  final String path;
  final int status;

  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
    required this.timestamp,
    required this.path,
    required this.status,
  });
}

class ApiError {
  final String? field;
  final String? code;
  final String message;

  ApiError({
    this.field,
    this.code,
    required this.message,
  });
}
```

Nguyên tắc:

* Không chỉ kiểm tra HTTP status code.
* Cần kiểm tra cả `success`, `message`, `data`, `errors`, `status`.
* Lỗi validation cần hiển thị gần field tương ứng.
* Lỗi nghiệp vụ cần hiển thị bằng snackbar/dialog dễ hiểu.
* App không hiển thị stack trace hoặc lỗi kỹ thuật thô cho user.

---

# 10. Danh sách task Flutter App

## BS-APP-01 – Khởi tạo Flutter Project

### Mô tả

Khởi tạo project Flutter cho Mobile App BookSphere theo cấu trúc chuẩn product, hỗ trợ Android trước và có thể mở rộng iOS sau.

### Requirement

* Sử dụng Flutter stable.
* Project chạy được trên Android emulator hoặc Android thật.
* Có cấu trúc thư mục rõ ràng.
* Có cấu hình environment.
* Có theme cơ bản.

### Checklist

* [ ] Tạo project `booksphere_app`.
* [ ] Cấu hình package name.
* [ ] Cài dependencies cần thiết.
* [ ] Tạo cấu trúc thư mục chuẩn.
* [ ] Cấu hình Material 3 theme.
* [ ] Cấu hình asset folder.
* [ ] Tạo file app config.
* [ ] Chạy được `flutter pub get`.
* [ ] Chạy được `flutter run`.
* [ ] Build được APK bằng `flutter build apk`.

---

## BS-APP-02 – Cấu hình Dependencies

### Mô tả

Cài đặt các package cần thiết cho App như routing, HTTP client, secure storage, state management, local cache và testing.

### Requirement

* Có đầy đủ package cho việc gọi API.
* Có secure storage để lưu token.
* Có routing.
* Có state management.
* Có package format ngày tiền tệ.

### Checklist

* [ ] Cài `dio`.
* [ ] Cài `flutter_secure_storage`.
* [ ] Cài `go_router`.
* [ ] Cài `flutter_riverpod` hoặc `bloc`.
* [ ] Cài `intl`.
* [ ] Cài `shared_preferences` hoặc `hive`.
* [ ] Cài `json_annotation`.
* [ ] Cài `json_serializable`.
* [ ] Cài `build_runner`.
* [ ] Cài `mocktail` cho testing.
* [ ] Cấu hình import và version ổn định.

---

## BS-APP-03 – Xây dựng App Config và Environment

### Mô tả

Xây dựng cấu hình môi trường cho App để dễ thay đổi API URL giữa local, emulator, thiết bị thật và production.

### Requirement

* Không hard-code API URL trong từng file.
* API base URL lấy từ config.
* Có hướng dẫn chạy với `--dart-define`.

### Checklist

* [ ] Tạo `AppConfig`.
* [ ] Tạo `ApiEndpoints`.
* [ ] Cấu hình `API_BASE_URL`.
* [ ] Hỗ trợ Android emulator URL.
* [ ] Hỗ trợ real device URL.
* [ ] Hỗ trợ production URL.
* [ ] Viết hướng dẫn chạy app với `--dart-define`.

---

## BS-APP-04 – Xây dựng Dio Client

### Mô tả

Xây dựng HTTP client dùng Dio để gọi API Gateway. Dio Client cần gắn token, xử lý lỗi, parse response và refresh token khi cần.

### Requirement

* Tất cả API đi qua API Gateway.
* Tự động gắn access token.
* Tự động refresh token khi access token hết hạn.
* Xử lý lỗi tập trung.

### Checklist

* [ ] Tạo `dio_client.dart`.
* [ ] Cấu hình base URL từ `AppConfig`.
* [ ] Cấu hình timeout.
* [ ] Tạo request interceptor.
* [ ] Gắn header `Authorization: Bearer {accessToken}`.
* [ ] Tạo response interceptor.
* [ ] Parse `ApiResponse<T>`.
* [ ] Tạo error interceptor.
* [ ] Bắt lỗi `401`.
* [ ] Gọi refresh token khi access token hết hạn.
* [ ] Retry request cũ sau khi refresh thành công.
* [ ] Nếu refresh token hết hạn thì logout.
* [ ] Không gọi trực tiếp service port `8081`, `8082`, `8083`, `8084`, `8085`.

---

## BS-APP-05 – Secure Token Storage

### Mô tả

Xây dựng service lưu token an toàn trên thiết bị bằng `flutter_secure_storage`.

### Requirement

* Access token và refresh token không lưu bằng biến tạm.
* Token cần tồn tại sau khi user tắt/mở lại app.
* Logout phải xóa toàn bộ token.

### Checklist

* [ ] Tạo `secure_storage_service.dart`.
* [ ] Lưu access token.
* [ ] Lưu refresh token.
* [ ] Lưu user role.
* [ ] Lưu user ID nếu cần.
* [ ] Đọc access token khi mở app.
* [ ] Đọc refresh token khi cần.
* [ ] Xóa token khi logout.
* [ ] Không lưu password.
* [ ] Không log token ra console.

---

## BS-APP-06 – Splash Screen và Auth Guard

### Mô tả

Xây dựng màn hình splash để kiểm tra trạng thái đăng nhập khi mở app.

### Requirement

* Nếu chưa có token thì chuyển về login.
* Nếu có token hợp lệ thì vào màn hình chính.
* Nếu access token hết hạn nhưng refresh token còn hạn thì tự refresh.
* Nếu refresh fail thì logout.

### Checklist

* [ ] Tạo `SplashScreen`.
* [ ] Kiểm tra access token trong secure storage.
* [ ] Kiểm tra refresh token.
* [ ] Gọi refresh token nếu cần.
* [ ] Điều hướng đến `/login` nếu chưa đăng nhập.
* [ ] Điều hướng đến `/main` nếu đã đăng nhập.
* [ ] Không để splash loading vô hạn.
* [ ] Hiển thị lỗi kết nối nếu server không phản hồi.

---

## BS-APP-07 – Login Screen

### Mô tả

Xây dựng màn hình đăng nhập cho người dùng Mobile App.

### Requirement

* Gọi `POST /api/auth/login`.
* Đăng nhập bằng username/password.
* Lưu access token, refresh token và role.
* Tài khoản inactive phải bị chặn.
* Sai tài khoản hiển thị lỗi rõ ràng.

### Checklist

* [ ] Tạo `LoginScreen`.
* [ ] Tạo form username.
* [ ] Tạo form password.
* [ ] Validate username không rỗng.
* [ ] Validate password không rỗng.
* [ ] Có nút hiện/ẩn password.
* [ ] Gọi API login.
* [ ] Hiển thị loading khi đăng nhập.
* [ ] Lưu access token.
* [ ] Lưu refresh token.
* [ ] Lưu role.
* [ ] Login thành công chuyển đến `/main`.
* [ ] Sai tài khoản hiển thị lỗi `AUTH_INVALID_CREDENTIALS`.
* [ ] Tài khoản inactive hiển thị lỗi `AUTH_ACCOUNT_INACTIVE`.
* [ ] Không cho user đã login quay lại login.

---

## BS-APP-08 – Register Screen

### Mô tả

Xây dựng màn hình đăng ký tài khoản mới cho người dùng.

### Requirement

* Gọi `POST /api/auth/register`.
* Tài khoản đăng ký mặc định là `MEMBER`.
* Validate dữ liệu đầu vào.
* Đăng ký thành công chuyển về login.

### Checklist

* [ ] Tạo `RegisterScreen`.
* [ ] Nhập full name.
* [ ] Nhập username.
* [ ] Nhập email.
* [ ] Nhập phone.
* [ ] Nhập password.
* [ ] Nhập confirm password nếu cần.
* [ ] Validate required fields.
* [ ] Validate email format.
* [ ] Validate password.
* [ ] Validate confirm password trùng password.
* [ ] Gọi API register.
* [ ] Handle lỗi username trùng.
* [ ] Handle lỗi email trùng.
* [ ] Hiển thị snackbar đăng ký thành công.
* [ ] Chuyển về login sau khi đăng ký thành công.

---

## BS-APP-09 – Logout

### Mô tả

Xây dựng chức năng đăng xuất khỏi Mobile App.

### Requirement

* Gọi `POST /api/auth/logout`.
* Xóa token trong secure storage.
* Xóa state user trong app.
* Điều hướng về login.

### Checklist

* [ ] Tạo hàm logout trong `AuthRepository`.
* [ ] Gọi API logout.
* [ ] Xóa access token.
* [ ] Xóa refresh token.
* [ ] Xóa user role.
* [ ] Xóa cache liên quan đến user nếu cần.
* [ ] Chuyển về `/login`.
* [ ] Không cho back về màn hình chính sau logout.

---

## BS-APP-10 – Main Tab Layout

### Mô tả

Xây dựng layout chính của App sau khi đăng nhập, sử dụng bottom navigation.

### Requirement

* Có bottom navigation.
* Có AppBar.
* Có notification icon.
* Giữ state từng tab nếu cần.
* Điều hướng mượt giữa các tab.

### Checklist

* [ ] Tạo `MainTabScreen`.
* [ ] Tạo tab Home.
* [ ] Tạo tab Books.
* [ ] Tạo tab My Borrows.
* [ ] Tạo tab My Fines.
* [ ] Tạo tab Profile.
* [ ] Tạo AppBar chung.
* [ ] Thêm notification icon.
* [ ] Hiển thị notification badge.
* [ ] Điều hướng giữa các tab.
* [ ] Không reload dữ liệu không cần thiết.

---

## BS-APP-11 – Home Screen

### Mô tả

Xây dựng trang Home cho MEMBER, hiển thị tổng quan nhanh về tình trạng mượn sách và thông báo.

### Requirement

* Hiển thị thông tin chào user.
* Hiển thị sách đang mượn.
* Hiển thị phiếu quá hạn nếu có.
* Hiển thị fine chưa thanh toán nếu có.
* Hiển thị notification mới.

### Checklist

* [ ] Tạo `HomeScreen`.
* [ ] Hiển thị lời chào user.
* [ ] Hiển thị số phiếu đang mượn.
* [ ] Hiển thị số phiếu quá hạn.
* [ ] Hiển thị số fine chưa thanh toán.
* [ ] Hiển thị notification mới nhất.
* [ ] Có nút xem sách.
* [ ] Có nút xem phiếu mượn.
* [ ] Có nút xem fine.
* [ ] Có loading state.
* [ ] Có empty state.
* [ ] Có pull-to-refresh.

---

## BS-APP-12 – Book List Screen

### Mô tả

Xây dựng màn hình danh sách sách cho Mobile App.

### Requirement

* Gọi `GET /api/books`.
* Hiển thị danh sách sách dạng card.
* Có tìm kiếm.
* Có filter category.
* Có pagination hoặc infinite scroll.
* Có pull-to-refresh.

### Checklist

* [ ] Tạo `BookListScreen`.
* [ ] Tạo `BookCard`.
* [ ] Gọi API danh sách sách.
* [ ] Hiển thị title.
* [ ] Hiển thị author.
* [ ] Hiển thị category.
* [ ] Hiển thị available quantity.
* [ ] Hiển thị trạng thái còn sách/hết sách.
* [ ] Tạo ô search.
* [ ] Search theo title.
* [ ] Search theo author.
* [ ] Search theo ISBN.
* [ ] Filter theo category.
* [ ] Infinite scroll hoặc pagination.
* [ ] Pull-to-refresh.
* [ ] Loading state.
* [ ] Empty state.
* [ ] Error state.

---

## BS-APP-13 – Book Detail Screen

### Mô tả

Xây dựng màn hình chi tiết sách trên App.

### Requirement

* Gọi `GET /api/books/{id}`.
* Hiển thị đầy đủ thông tin sách.
* Nếu sách còn hàng, MEMBER có thể tạo phiếu mượn.
* Nếu sách hết hàng, disable nút mượn.

### Checklist

* [ ] Tạo `BookDetailScreen`.
* [ ] Gọi API chi tiết sách.
* [ ] Hiển thị title.
* [ ] Hiển thị author.
* [ ] Hiển thị ISBN.
* [ ] Hiển thị publisher.
* [ ] Hiển thị published year.
* [ ] Hiển thị category.
* [ ] Hiển thị total quantity.
* [ ] Hiển thị available quantity.
* [ ] Hiển thị description.
* [ ] Hiển thị trạng thái còn/hết sách.
* [ ] Nút mượn sách.
* [ ] Disable nút mượn nếu hết sách.
* [ ] Điều hướng sang Borrow Create.
* [ ] Có loading state.
* [ ] Có not found state.

---

## BS-APP-14 – Book Search và Filter

### Mô tả

Xây dựng chức năng tìm kiếm và lọc sách phù hợp với trải nghiệm mobile.

### Requirement

* Search realtime có debounce.
* Filter category bằng bottom sheet.
* Có nút clear filter.
* Không gọi API quá nhiều.

### Checklist

* [ ] Tạo `BookSearchScreen` hoặc search trong `BookListScreen`.
* [ ] Thêm debounce search.
* [ ] Tạo `BookFilterSheet`.
* [ ] Load danh sách category.
* [ ] Chọn category.
* [ ] Clear filter.
* [ ] Apply filter.
* [ ] Hiển thị số filter đang áp dụng.
* [ ] Không mất filter khi reload.
* [ ] Hiển thị empty state khi không tìm thấy sách.

---

## BS-APP-15 – Borrow Create Screen

### Mô tả

Xây dựng màn hình tạo phiếu mượn sách từ App.

### Requirement

* Gọi `POST /api/borrows`.
* Không tự trừ tồn kho ở App.
* Backend xử lý Borrow Saga.
* Nếu BE trả lỗi hết sách hoặc sách inactive, App hiển thị lỗi rõ ràng.

### Checklist

* [ ] Tạo `BorrowCreateScreen`.
* [ ] Nhận book ID từ Book Detail.
* [ ] Hiển thị thông tin sách đang mượn.
* [ ] Nhập quantity.
* [ ] Validate quantity > 0.
* [ ] Validate quantity không vượt available quantity đang hiển thị.
* [ ] Chọn due date nếu BE hỗ trợ.
* [ ] Hiển thị confirm trước khi mượn.
* [ ] Gọi API tạo phiếu mượn.
* [ ] Hiển thị loading khi submit.
* [ ] Mượn thành công chuyển về My Borrows.
* [ ] Handle lỗi `BOOK_OUT_OF_STOCK`.
* [ ] Handle lỗi `BOOK_INACTIVE`.
* [ ] Handle lỗi `BORROW_SAGA_FAILED`.
* [ ] Reload book detail sau khi mượn thành công.

---

## BS-APP-16 – My Borrow List Screen

### Mô tả

Xây dựng màn hình hiển thị danh sách phiếu mượn của người dùng hiện tại.

### Requirement

* Gọi API lấy phiếu mượn của user hiện tại.
* Chỉ hiển thị dữ liệu của user đang đăng nhập.
* Có filter status.
* Có pull-to-refresh.

### Checklist

* [ ] Tạo `MyBorrowListScreen`.
* [ ] Tạo `BorrowCard`.
* [ ] Gọi API my borrows.
* [ ] Hiển thị borrow ID.
* [ ] Hiển thị borrow date.
* [ ] Hiển thị due date.
* [ ] Hiển thị return date.
* [ ] Hiển thị status.
* [ ] Hiển thị status chip.
* [ ] Filter `BORROWING`.
* [ ] Filter `OVERDUE`.
* [ ] Filter `RETURNED`.
* [ ] Filter `CANCELLED`.
* [ ] Nhấn card để xem chi tiết.
* [ ] Pull-to-refresh.
* [ ] Loading state.
* [ ] Empty state.

---

## BS-APP-17 – Borrow Detail Screen

### Mô tả

Xây dựng màn hình chi tiết phiếu mượn.

### Requirement

* Gọi `GET /api/borrows/{borrowId}`.
* Hiển thị danh sách sách trong phiếu.
* Cho phép trả sách nếu phiếu đang `BORROWING` hoặc `OVERDUE`.

### Checklist

* [ ] Tạo `BorrowDetailScreen`.
* [ ] Gọi API chi tiết borrow.
* [ ] Hiển thị borrow status.
* [ ] Hiển thị borrow date.
* [ ] Hiển thị due date.
* [ ] Hiển thị return date.
* [ ] Hiển thị danh sách borrow items.
* [ ] Hiển thị quantity từng item.
* [ ] Hiển thị trạng thái từng item.
* [ ] Hiển thị cảnh báo nếu quá hạn.
* [ ] Có nút return book nếu status hợp lệ.
* [ ] Ẩn nút return nếu đã trả.
* [ ] Có loading state.
* [ ] Có error state.

---

## BS-APP-18 – Return Book Flow

### Mô tả

Xây dựng luồng trả sách trên Mobile App.

### Requirement

* Gọi `POST /api/borrows/{borrowId}/return`.
* Có confirm dialog trước khi trả.
* Nếu trả trễ, App thông báo có thể phát sinh tiền phạt.
* Nếu phiếu đã trả, App hiển thị lỗi nghiệp vụ.

### Checklist

* [ ] Tạo confirm dialog trả sách.
* [ ] Hiển thị thông tin phiếu trước khi xác nhận.
* [ ] Cảnh báo nếu phiếu đang quá hạn.
* [ ] Gọi API return book.
* [ ] Hiển thị loading khi xử lý.
* [ ] Return thành công reload borrow detail.
* [ ] Return thành công reload my borrows.
* [ ] Nếu trả trễ, hiển thị message về fine.
* [ ] Handle lỗi `BORROW_ALREADY_RETURNED`.
* [ ] Handle lỗi `BORROW_NOT_FOUND`.
* [ ] Handle lỗi `BORROW_NOT_ALLOWED`.
* [ ] Không cho bấm nhiều lần khi đang loading.

---

## BS-APP-19 – My Fine List Screen

### Mô tả

Xây dựng màn hình danh sách tiền phạt của người dùng hiện tại.

### Requirement

* Gọi API lấy fine của user hiện tại.
* Hiển thị fine unpaid/paid.
* Fine chưa thanh toán có nút thanh toán.
* Có filter status.

### Checklist

* [ ] Tạo `MyFineListScreen`.
* [ ] Tạo `FineCard`.
* [ ] Gọi API my fines.
* [ ] Hiển thị fine ID.
* [ ] Hiển thị borrow ID.
* [ ] Hiển thị amount.
* [ ] Hiển thị reason.
* [ ] Hiển thị status.
* [ ] Hiển thị created at.
* [ ] Hiển thị paid at nếu có.
* [ ] Filter `UNPAID`.
* [ ] Filter `PAID`.
* [ ] Filter `CANCELLED`.
* [ ] Fine unpaid có nút thanh toán.
* [ ] Fine paid không có nút thanh toán.
* [ ] Pull-to-refresh.
* [ ] Empty state.

---

## BS-APP-20 – Fine Detail Screen

### Mô tả

Xây dựng màn hình chi tiết tiền phạt.

### Requirement

* Gọi API chi tiết fine.
* Hiển thị thông tin khoản phạt.
* Cho phép thanh toán nếu fine chưa paid.

### Checklist

* [ ] Tạo `FineDetailScreen`.
* [ ] Gọi API fine detail.
* [ ] Hiển thị fine ID.
* [ ] Hiển thị borrow ID.
* [ ] Hiển thị amount.
* [ ] Hiển thị reason.
* [ ] Hiển thị created from.
* [ ] Hiển thị status.
* [ ] Hiển thị created at.
* [ ] Hiển thị paid at.
* [ ] Có nút thanh toán nếu `UNPAID`.
* [ ] Ẩn nút thanh toán nếu `PAID`.
* [ ] Có loading state.
* [ ] Có error state.

---

## BS-APP-21 – Fine Payment Flow

### Mô tả

Xây dựng luồng thanh toán tiền phạt trên App.

### Requirement

* Gọi `POST /api/fines/{fineId}/pay`.
* Chọn payment method.
* Không cho thanh toán fine đã paid.
* Sau khi thanh toán thành công, reload dữ liệu.

### Checklist

* [ ] Tạo `FinePaymentScreen`.
* [ ] Tạo `PaymentMethodSheet`.
* [ ] Hiển thị amount cần thanh toán.
* [ ] Chọn `CASH`.
* [ ] Chọn `BANK_TRANSFER`.
* [ ] Chọn `E_WALLET`.
* [ ] Confirm trước khi thanh toán.
* [ ] Gọi API pay fine.
* [ ] Hiển thị loading khi thanh toán.
* [ ] Thanh toán thành công hiển thị snackbar.
* [ ] Thanh toán thành công reload fine list.
* [ ] Thanh toán thành công reload fine detail.
* [ ] Handle lỗi `FINE_ALREADY_PAID`.
* [ ] Handle lỗi `FINE_NOT_FOUND`.
* [ ] Handle lỗi `FINE_PAYMENT_FAILED`.

---

## BS-APP-22 – Notification List Screen

### Mô tả

Xây dựng màn hình danh sách notification trong App.

### Requirement

* Gọi API notification của user hiện tại.
* Hiển thị notification theo type.
* Có unread/read state.
* Có mark as read.
* Có pull-to-refresh.

### Checklist

* [ ] Tạo `NotificationListScreen`.
* [ ] Tạo `NotificationTile`.
* [ ] Gọi API notifications.
* [ ] Hiển thị title.
* [ ] Hiển thị content.
* [ ] Hiển thị type.
* [ ] Hiển thị created at.
* [ ] Hiển thị trạng thái read/unread.
* [ ] Filter unread nếu cần.
* [ ] Mark notification as read.
* [ ] Click notification điều hướng đến borrow/fine liên quan nếu có.
* [ ] Pull-to-refresh.
* [ ] Empty state.
* [ ] Error state.

---

## BS-APP-23 – Notification Badge trên AppBar

### Mô tả

Xây dựng badge thông báo chưa đọc trên AppBar hoặc Home screen.

### Requirement

* Hiển thị số notification chưa đọc.
* Tự refresh khi vào app.
* Refresh sau khi mark as read.

### Checklist

* [ ] Tạo `NotificationBadge`.
* [ ] Gọi API unread count nếu BE hỗ trợ.
* [ ] Nếu BE chưa có unread count, tính từ danh sách notification.
* [ ] Hiển thị badge trên icon.
* [ ] Badge ẩn khi unread = 0.
* [ ] Click icon mở Notification screen.
* [ ] Reload badge sau khi đọc notification.

---

## BS-APP-24 – Profile Screen

### Mô tả

Xây dựng màn hình thông tin cá nhân.

### Requirement

* Hiển thị thông tin user.
* Không hiển thị password.
* Có nút logout.
* Có thể mở rộng đổi mật khẩu nếu BE hỗ trợ.

### Checklist

* [ ] Tạo `ProfileScreen`.
* [ ] Hiển thị full name.
* [ ] Hiển thị username.
* [ ] Hiển thị email.
* [ ] Hiển thị phone.
* [ ] Hiển thị role.
* [ ] Hiển thị trạng thái tài khoản nếu có.
* [ ] Có nút settings.
* [ ] Có nút logout.
* [ ] Confirm trước khi logout.
* [ ] Không hiển thị thông tin nhạy cảm.

---

## BS-APP-25 – Settings Screen

### Mô tả

Xây dựng màn hình cài đặt cơ bản cho App.

### Requirement

* Có thông tin app.
* Có cài đặt theme nếu cần.
* Có logout.
* Có version app.

### Checklist

* [ ] Tạo `SettingsScreen`.
* [ ] Hiển thị app name.
* [ ] Hiển thị app version.
* [ ] Hiển thị API environment nếu cần cho dev.
* [ ] Toggle dark mode nếu làm.
* [ ] Nút logout.
* [ ] Link về thông tin hệ thống nếu cần.

---

## BS-APP-26 – Error Handling chuẩn Mobile

### Mô tả

Chuẩn hóa xử lý lỗi toàn App để người dùng không nhìn thấy lỗi kỹ thuật.

### Requirement

* Map lỗi từ Backend sang message dễ hiểu.
* Lỗi form hiển thị dưới field.
* Lỗi nghiệp vụ hiển thị bằng snackbar/dialog.
* Lỗi auth tự logout hoặc refresh token.

### Checklist

* [ ] Tạo `error_mapper.dart`.
* [ ] Map lỗi `AUTH_INVALID_CREDENTIALS`.
* [ ] Map lỗi `AUTH_TOKEN_EXPIRED`.
* [ ] Map lỗi `AUTH_REFRESH_TOKEN_INVALID`.
* [ ] Map lỗi `AUTH_ACCOUNT_INACTIVE`.
* [ ] Map lỗi `BOOK_NOT_FOUND`.
* [ ] Map lỗi `BOOK_INACTIVE`.
* [ ] Map lỗi `BOOK_OUT_OF_STOCK`.
* [ ] Map lỗi `BORROW_NOT_FOUND`.
* [ ] Map lỗi `BORROW_ALREADY_RETURNED`.
* [ ] Map lỗi `BORROW_NOT_ALLOWED`.
* [ ] Map lỗi `BORROW_SAGA_FAILED`.
* [ ] Map lỗi `FINE_NOT_FOUND`.
* [ ] Map lỗi `FINE_ALREADY_PAID`.
* [ ] Map lỗi `FINE_PAYMENT_FAILED`.
* [ ] Map lỗi `NOTIFICATION_NOT_FOUND`.
* [ ] Map lỗi `RATE_LIMIT_EXCEEDED`.
* [ ] Map lỗi `SERVICE_UNAVAILABLE`.
* [ ] Map lỗi `INTERNAL_SERVER_ERROR`.
* [ ] Không hiển thị raw exception cho user.

---

## BS-APP-27 – Loading, Empty State và Pull-to-Refresh

### Mô tả

Chuẩn hóa trải nghiệm mobile cho các màn hình gọi API.

### Requirement

* Màn hình nào gọi API cũng có loading.
* Danh sách rỗng có empty state.
* Danh sách chính có pull-to-refresh.
* Button action có loading để tránh double submit.

### Checklist

* [ ] Tạo `AppLoading`.
* [ ] Tạo `AppEmptyState`.
* [ ] Tạo `AppErrorView`.
* [ ] Tạo loading button.
* [ ] Book list có pull-to-refresh.
* [ ] My borrows có pull-to-refresh.
* [ ] My fines có pull-to-refresh.
* [ ] Notifications có pull-to-refresh.
* [ ] Disable button khi submit.
* [ ] Không cho bấm nhiều lần khi đang loading.

---

## BS-APP-28 – Local Cache cơ bản

### Mô tả

Xây dựng cache local cơ bản để App mượt hơn và vẫn có thể hiển thị dữ liệu gần nhất khi mạng yếu.

### Requirement

* Cache danh sách sách gần nhất.
* Cache profile/user info.
* Cache notification gần nhất nếu cần.
* Khi mất mạng, hiển thị dữ liệu cache kèm cảnh báo.

### Checklist

* [ ] Tạo `local_cache_service.dart`.
* [ ] Cache book list.
* [ ] Cache category list.
* [ ] Cache user info.
* [ ] Cache notification gần nhất nếu cần.
* [ ] Khi API lỗi mạng, thử đọc cache.
* [ ] Hiển thị message “Đang hiển thị dữ liệu gần nhất”.
* [ ] Có nút retry.
* [ ] Không cache dữ liệu nhạy cảm như password/token trong local cache thường.

---

## BS-APP-29 – Mobile UI Polish

### Mô tả

Hoàn thiện giao diện mobile theo hướng product, dễ dùng và phù hợp thao tác một tay.

### Requirement

* Giao diện rõ ràng.
* Button dễ bấm.
* Card dễ đọc.
* Status màu sắc thống nhất.
* Form không bị tràn.

### Checklist

* [ ] Áp dụng Material 3 theme.
* [ ] Tạo màu chính cho BookSphere.
* [ ] Tạo typography thống nhất.
* [ ] Tạo spacing thống nhất.
* [ ] Thiết kế BookCard rõ ràng.
* [ ] Thiết kế BorrowCard rõ ràng.
* [ ] Thiết kế FineCard rõ ràng.
* [ ] Thiết kế NotificationTile rõ ràng.
* [ ] Status chip cho `BORROWING`.
* [ ] Status chip cho `OVERDUE`.
* [ ] Status chip cho `RETURNED`.
* [ ] Status chip cho `UNPAID`.
* [ ] Status chip cho `PAID`.
* [ ] Kiểm tra trên màn hình nhỏ.
* [ ] Kiểm tra trên màn hình lớn.

---

## BS-APP-30 – Testing Flutter App

### Mô tả

Viết test cơ bản cho các màn hình và logic quan trọng của App.

### Requirement

* Có unit test cho error mapper.
* Có test cho auth provider.
* Có widget test cho màn hình login.
* Có test cho form validation.

### Checklist

* [ ] Cấu hình `flutter_test`.
* [ ] Cài `mocktail`.
* [ ] Test error mapper.
* [ ] Test secure storage service mock.
* [ ] Test auth provider login success.
* [ ] Test auth provider login failed.
* [ ] Test LoginScreen render.
* [ ] Test LoginScreen validation.
* [ ] Test BookCard render.
* [ ] Test Borrow status chip.
* [ ] Test Fine status chip.
* [ ] Chạy được `flutter test`.

---

## BS-APP-31 – Build Android APK

### Mô tả

Build App thành APK để cài thử trên điện thoại Android thật.

### Requirement

* Build được APK debug hoặc release.
* App chạy được trên thiết bị thật.
* API URL trỏ đúng IP máy chạy Backend hoặc server deploy.

### Checklist

* [ ] Cấu hình app name.
* [ ] Cấu hình app icon nếu có.
* [ ] Cấu hình internet permission Android.
* [ ] Build debug APK.
* [ ] Build release APK nếu cần.
* [ ] Cài APK lên điện thoại.
* [ ] Test login trên điện thoại thật.
* [ ] Test gọi API Gateway từ điện thoại.
* [ ] Test mượn sách.
* [ ] Test trả sách.
* [ ] Test notification.
* [ ] Ghi chú cách build trong README.

---

## BS-APP-32 – Documentation Mobile App

### Mô tả

Viết tài liệu hướng dẫn chạy App, cấu hình API URL, build APK và demo.

### Requirement

* Có hướng dẫn setup Flutter.
* Có hướng dẫn chạy app.
* Có hướng dẫn kết nối Backend local.
* Có hướng dẫn build APK.
* Có account demo.
* Có flow demo.

### Checklist

* [ ] Viết README cho App.
* [ ] Ghi Flutter version.
* [ ] Ghi cách chạy `flutter pub get`.
* [ ] Ghi cách chạy app bằng emulator.
* [ ] Ghi cách chạy app bằng điện thoại thật.
* [ ] Ghi cách truyền `API_BASE_URL`.
* [ ] Ghi cách build APK.
* [ ] Ghi account demo MEMBER.
* [ ] Ghi flow demo.
* [ ] Ghi lỗi thường gặp khi không gọi được API local.

---

## BS-APP-33 – Final Mobile Demo Integration

### Mô tả

Kiểm thử tích hợp App với toàn bộ Backend thông qua API Gateway.

### Requirement

* Backend chạy đầy đủ.
* App gọi được API Gateway.
* Login hoạt động.
* Xem sách hoạt động.
* Mượn sách hoạt động.
* Trả sách hoạt động.
* Fine hoạt động.
* Notification hoạt động.

### Checklist

* [ ] Chạy Discovery Server.
* [ ] Chạy Config Server.
* [ ] Chạy API Gateway.
* [ ] Chạy Auth Service.
* [ ] Chạy Book Service.
* [ ] Chạy Borrow Service.
* [ ] Chạy Fine Service.
* [ ] Chạy Notification Service.
* [ ] Chạy App Flutter.
* [ ] Login bằng tài khoản MEMBER.
* [ ] Xem danh sách sách.
* [ ] Tìm kiếm sách.
* [ ] Xem chi tiết sách.
* [ ] Mượn sách.
* [ ] Kiểm tra phiếu xuất hiện trong My Borrows.
* [ ] Trả sách.
* [ ] Kiểm tra Fine nếu trả trễ.
* [ ] Thanh toán Fine.
* [ ] Kiểm tra Notification.
* [ ] Logout.
* [ ] Quay video hoặc chụp màn hình demo nếu cần.

---

# 11. Luồng demo chính trên Flutter App

## 11.1 Luồng mở App

```txt
User mở App
    → SplashScreen kiểm tra token
    → Nếu chưa login: chuyển LoginScreen
    → Nếu token hợp lệ: chuyển MainTabScreen
    → Nếu access token hết hạn: refresh token
    → Nếu refresh fail: logout và chuyển LoginScreen
```

## 11.2 Luồng đăng nhập

```txt
User nhập username/password
    → App gọi POST /api/auth/login
    → Backend trả accessToken + refreshToken + role
    → App lưu token bằng flutter_secure_storage
    → App chuyển vào MainTabScreen
```

## 11.3 Luồng xem sách

```txt
User vào tab Books
    → App gọi GET /api/books
    → Hiển thị danh sách sách dạng card
    → User search/filter sách
    → User nhấn vào sách
    → App mở BookDetailScreen
```

## 11.4 Luồng mượn sách

```txt
User mở BookDetailScreen
    → Nếu sách còn hàng, nhấn Borrow
    → App mở BorrowCreateScreen
    → User nhập quantity
    → App gọi POST /api/borrows
    → Backend xử lý Borrow Saga
    → Book Service giảm tồn kho
    → Borrow Service tạo phiếu mượn
    → Notification Service tạo thông báo
    → App chuyển về MyBorrowListScreen
```

## 11.5 Luồng trả sách

```txt
User vào My Borrows
    → Mở BorrowDetailScreen
    → Nhấn Return Book
    → App hiển thị Confirm Dialog
    → App gọi POST /api/borrows/{borrowId}/return
    → Backend xử lý Return Book Saga
    → Book Service tăng tồn kho
    → Nếu trả trễ, Fine Service tạo Fine
    → Notification Service tạo thông báo
    → App reload Borrow Detail
```

## 11.6 Luồng thanh toán tiền phạt

```txt
User vào My Fines
    → Chọn fine UNPAID
    → Mở FineDetailScreen
    → Nhấn Pay Fine
    → Chọn payment method
    → App gọi POST /api/fines/{fineId}/pay
    → Fine Service cập nhật Fine = PAID
    → App reload My Fines
```

## 11.7 Luồng notification

```txt
User nhấn icon Notification
    → App mở NotificationListScreen
    → App gọi GET /api/notifications/my
    → User đọc notification
    → App gọi PUT /api/notifications/{id}/read
    → Badge unread count giảm
```

---

# 12. Thứ tự triển khai khuyến nghị

| Giai đoạn                     | Task                                                             |
| ----------------------------- | ---------------------------------------------------------------- |
| Phase 1 – Nền tảng App        | BS-APP-01, BS-APP-02, BS-APP-03                                  |
| Phase 2 – Network & Auth      | BS-APP-04, BS-APP-05, BS-APP-06, BS-APP-07, BS-APP-08, BS-APP-09 |
| Phase 3 – Layout chính        | BS-APP-10, BS-APP-11                                             |
| Phase 4 – Book Module         | BS-APP-12, BS-APP-13, BS-APP-14                                  |
| Phase 5 – Borrow Module       | BS-APP-15, BS-APP-16, BS-APP-17, BS-APP-18                       |
| Phase 6 – Fine Module         | BS-APP-19, BS-APP-20, BS-APP-21                                  |
| Phase 7 – Notification Module | BS-APP-22, BS-APP-23                                             |
| Phase 8 – Profile & Settings  | BS-APP-24, BS-APP-25                                             |
| Phase 9 – Product Polish      | BS-APP-26, BS-APP-27, BS-APP-28, BS-APP-29                       |
| Phase 10 – Test & Build       | BS-APP-30, BS-APP-31, BS-APP-32, BS-APP-33                       |

---

# 13. Definition of Done chung cho Flutter App

| Nhóm              | Điều kiện hoàn thành                                                      |
| ----------------- | ------------------------------------------------------------------------- |
| Code Quality      | Code rõ ràng, tách layer data/provider/presentation                       |
| Build             | `flutter build apk` thành công                                            |
| API               | Tất cả API gọi qua API Gateway                                            |
| Auth              | Login, refresh token, logout hoạt động                                    |
| Storage           | Token lưu bằng secure storage                                             |
| UX                | Có loading, empty state, error state, snackbar, confirm dialog            |
| Book Flow         | Xem sách, tìm kiếm sách, xem chi tiết sách hoạt động                      |
| Borrow Flow       | Mượn sách, xem phiếu mượn, trả sách hoạt động                             |
| Fine Flow         | Xem tiền phạt và thanh toán tiền phạt hoạt động                           |
| Notification Flow | Xem notification, mark as read, badge hoạt động                           |
| Offline Basic     | Có cache dữ liệu cơ bản hoặc message khi mất mạng                         |
| Testing           | Có test cơ bản cho auth, error mapper và widget chính                     |
| Documentation     | README App có hướng dẫn chạy, build APK và demo                           |
| Demo              | Có thể demo login → xem sách → mượn sách → trả sách → fine → notification |

---

# 14. Checklist demo tối thiểu cho Flutter App

* [ ] Cài App trên điện thoại Android.
* [ ] App mở được SplashScreen.
* [ ] Đăng nhập thành công bằng tài khoản MEMBER.
* [ ] Xem danh sách sách.
* [ ] Tìm kiếm sách.
* [ ] Xem chi tiết sách.
* [ ] Mượn sách thành công.
* [ ] Xem phiếu mượn trong My Borrows.
* [ ] Trả sách thành công.
* [ ] Xem notification sau khi mượn/trả sách.
* [ ] Xem fine nếu có phiếu trả trễ.
* [ ] Thanh toán fine thành công.
* [ ] Logout thành công.
* [ ] Mở lại app không bị lỗi token.
* [ ] Access token hết hạn được refresh token xử lý.
* [ ] App hiển thị lỗi rõ ràng khi Backend tắt hoặc service unavailable.

---

# 15. Lưu ý quan trọng khi làm Flutter App

* App chỉ gọi API qua API Gateway.
* Không gọi trực tiếp từng microservice nội bộ.
* Không tự xử lý nghiệp vụ Saga trong App.
* Không tự trừ số lượng sách ở App.
* App chỉ gửi request nghiệp vụ và hiển thị kết quả từ Backend.
* Backend là nơi xử lý mượn sách, trả sách, tạo fine và tạo notification.
* Token phải lưu bằng secure storage.
* Không lưu password trong App.
* Không log access token hoặc refresh token.
* Cần xử lý lỗi mạng vì mobile thường không ổn định như web.
* Cần có pull-to-refresh cho các danh sách chính.
* Cần kiểm tra trên thiết bị Android thật, không chỉ emulator.
* Khi chạy trên điện thoại thật, API URL phải là IP máy đang chạy Backend hoặc server deploy, không dùng `localhost`.

---

# 16. Gợi ý tích hợp Website và App trong cùng hệ thống

## 16.1 Vai trò Website

Website ReactJS nên tập trung vào:

* Quản lý sách.
* Quản lý category.
* Quản lý phiếu mượn.
* Quản lý tiền phạt.
* Dashboard.
* Các thao tác nghiệp vụ dành cho `ADMIN` và `LIBRARIAN`.

## 16.2 Vai trò Mobile App

Mobile App Flutter nên tập trung vào:

* Trải nghiệm người mượn sách.
* Xem sách nhanh.
* Mượn sách nhanh.
* Theo dõi phiếu mượn cá nhân.
* Nhận thông báo.
* Thanh toán tiền phạt.
* Quản lý thông tin cá nhân.

## 16.3 Nguyên tắc dùng chung Backend

```txt
ReactJS Website
        ↓
    API Gateway
        ↓
Microservices Backend

Flutter App
        ↓
    API Gateway
        ↓
Microservices Backend
```

Cả Website và App đều dùng chung hệ thống API hiện tại. Không cần xây dựng một Backend riêng cho App.

Chỉ cần đảm bảo:

* API response thống nhất.
* CORS cho Website được cấu hình đúng.
* Mobile App gọi được API Gateway qua network.
* Auth token dùng chung chuẩn.
* Role permission được xử lý ở Backend và kiểm tra bổ sung ở client.
* Các API dành cho App có thể tái sử dụng từ Website.
