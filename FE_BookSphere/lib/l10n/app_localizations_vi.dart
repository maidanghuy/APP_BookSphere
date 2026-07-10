// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get books => 'Sách';

  @override
  String get fines => 'Tiền phạt';

  @override
  String get booksScreenPlaceholder => 'Màn hình Sách - BS-APP-12';

  @override
  String get finesScreenPlaceholder => 'Màn hình Tiền phạt - Task sau';

  @override
  String get borrowingOverview => 'Tổng quan mượn sách';

  @override
  String get activeBorrows => 'Phiếu đang mượn';

  @override
  String get overdueBorrows => 'Phiếu quá hạn';

  @override
  String get unpaidFines => 'Tiền phạt chưa thanh toán';

  @override
  String get currentlyBorrowedBooks => 'Sách đang mượn';

  @override
  String get latestNotification => 'Thông báo mới nhất';

  @override
  String get mockLatestNotification => 'Sách Clean Code sắp đến hạn trả.';

  @override
  String get viewBooks => 'Xem sách';

  @override
  String get viewBorrows => 'Xem phiếu mượn';

  @override
  String get viewFines => 'Xem tiền phạt';

  @override
  String get homeEmptyTitle => 'Bạn chưa có hoạt động mượn sách.';

  @override
  String get hello => 'Xin chào';

  @override
  String get reader => 'Độc giả';

  @override
  String get welcomeBackToBookSphere => 'Chào mừng bạn trở lại BookSphere';

  @override
  String get searchBooks => 'Tìm kiếm sách...';

  @override
  String get clearSearch => 'Xóa tìm kiếm';

  @override
  String get searchFuturePlaceholder =>
      'Tính năng tìm kiếm sẽ được triển khai trong task sau.';

  @override
  String get featuredBooks => 'Sách nổi bật';

  @override
  String get recommendedForYou => 'Đề xuất cho bạn';

  @override
  String get categoryProgramming => 'Lập trình';

  @override
  String get categoryNovel => 'Tiểu thuyết';

  @override
  String get categoryScience => 'Khoa học';

  @override
  String get categoryHistory => 'Lịch sử';

  @override
  String get categoryTechnology => 'Công nghệ';

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
  String get selectTheme => 'Chọn giao diện';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

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
  String get registerScreenPlaceholder => 'Tạo tài khoản BookSphere mới';

  @override
  String get usernameRequired => 'Vui lòng nhập tên đăng nhập.';

  @override
  String get passwordRequired => 'Vui lòng nhập mật khẩu.';

  @override
  String get loginFailed => 'Không thể đăng nhập. Vui lòng thử lại.';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Số điện thoại';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get register => 'Đăng ký';

  @override
  String get alreadyHaveAccount => 'Bạn đã có tài khoản?';

  @override
  String get goToLogin => 'Đăng nhập';

  @override
  String get registerSuccess => 'Đăng ký thành công. Vui lòng đăng nhập.';

  @override
  String get usernameDuplicated => 'Tên đăng nhập đã tồn tại.';

  @override
  String get emailDuplicated => 'Email đã được sử dụng.';

  @override
  String get invalidEmail => 'Email không hợp lệ.';

  @override
  String get invalidPhone => 'Số điện thoại không hợp lệ.';

  @override
  String get passwordMinLength => 'Mật khẩu phải có ít nhất 6 ký tự.';

  @override
  String get confirmPasswordNotMatch => 'Mật khẩu xác nhận không khớp.';

  @override
  String get requiredField => 'Vui lòng nhập thông tin này.';

  @override
  String get fullNameRequired => 'Vui lòng nhập họ và tên.';

  @override
  String get emailRequired => 'Vui lòng nhập email.';

  @override
  String get phoneRequired => 'Vui lòng nhập số điện thoại.';

  @override
  String get confirmPasswordRequired => 'Vui lòng xác nhận mật khẩu.';

  @override
  String get invalidRegistrationData =>
      'Dữ liệu đăng ký không hợp lệ. Vui lòng kiểm tra lại.';

  @override
  String get registrationConflict => 'Thông tin đăng ký đã tồn tại.';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get logoutConfirmTitle => 'Xác nhận đăng xuất';

  @override
  String get logoutConfirmMessage => 'Bạn có chắc muốn đăng xuất không?';

  @override
  String get cancel => 'Hủy';

  @override
  String get logoutSuccess => 'Bạn đã đăng xuất.';

  @override
  String get logoutFailedButCleared =>
      'Không thể kết nối máy chủ, nhưng bạn đã được đăng xuất khỏi thiết bị này.';

  @override
  String get home => 'Trang chủ';

  @override
  String get categories => 'Danh mục';

  @override
  String get myBorrow => 'Sách đang mượn';

  @override
  String get notifications => 'Thông báo';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get homeScreenPlaceholder => 'Màn hình Trang chủ - BS-APP-11';

  @override
  String get categoryScreenPlaceholder => 'Màn hình Danh mục - BS-APP-13';

  @override
  String get borrowScreenPlaceholder => 'Màn hình Mượn sách - BS-APP-14';

  @override
  String get notificationScreenPlaceholder => 'Màn hình Thông báo - BS-APP-15';

  @override
  String get profileScreenPlaceholder => 'Màn hình Hồ sơ - BS-APP-16';
}
