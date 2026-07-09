// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'BookSphere';

  @override
  String get welcomeBack => 'Chào mừng trở lại';

  @override
  String get login => 'Đăng nhập';

  @override
  String get username => 'Tên đăng nhập';

  @override
  String get password => 'Mật khẩu';

  @override
  String get showPassword => 'Hiện mật khẩu';

  @override
  String get hidePassword => 'Ẩn mật khẩu';

  @override
  String get checkingSession => 'Đang kiểm tra phiên đăng nhập...';

  @override
  String get theme => 'Giao diện';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get lightMode => 'Sáng';

  @override
  String get darkMode => 'Tối';

  @override
  String get systemMode => 'Theo hệ thống';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get japanese => 'Tiếng Nhật';

  @override
  String get invalidCredentials => 'Tên đăng nhập hoặc mật khẩu không đúng.';

  @override
  String get accountInactive =>
      'Tài khoản đã bị khóa hoặc chưa được kích hoạt.';

  @override
  String get networkError =>
      'Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng hoặc API Gateway.';

  @override
  String get serverUnavailable =>
      'Hệ thống tạm thời không khả dụng. Vui lòng thử lại sau.';

  @override
  String get unknownError => 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.';

  @override
  String get retry => 'Thử lại';

  @override
  String get mainScreenPlaceholder =>
      'Màn hình chính sẽ được triển khai trong BS-APP-10';

  @override
  String get registerScreenPlaceholder =>
      'Màn hình đăng ký sẽ được triển khai trong BS-APP-08';

  @override
  String get usernameRequired => 'Vui lòng nhập tên đăng nhập.';

  @override
  String get passwordRequired => 'Vui lòng nhập mật khẩu.';

  @override
  String get loginFailed => 'Không thể đăng nhập. Vui lòng thử lại.';
}
