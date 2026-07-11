import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('vi'),
  ];

  /// No description provided for @notificationListTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notificationListTitle;

  /// No description provided for @allNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get allNotifications;

  /// No description provided for @unreadNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đọc'**
  String get unreadNotifications;

  /// No description provided for @noNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông báo'**
  String get noNotifications;

  /// No description provided for @noUnreadNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Không có thông báo chưa đọc'**
  String get noUnreadNotifications;

  /// No description provided for @markAsReadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đánh dấu thông báo là đã đọc.'**
  String get markAsReadFailed;

  /// No description provided for @notificationTypeBorrow.
  ///
  /// In vi, this message translates to:
  /// **'Mượn sách'**
  String get notificationTypeBorrow;

  /// No description provided for @notificationTypeReturn.
  ///
  /// In vi, this message translates to:
  /// **'Trả sách'**
  String get notificationTypeReturn;

  /// No description provided for @notificationTypeDueSoon.
  ///
  /// In vi, this message translates to:
  /// **'Sắp đến hạn'**
  String get notificationTypeDueSoon;

  /// No description provided for @notificationTypeOverdue.
  ///
  /// In vi, this message translates to:
  /// **'Quá hạn'**
  String get notificationTypeOverdue;

  /// No description provided for @notificationTypeFine.
  ///
  /// In vi, this message translates to:
  /// **'Tiền phạt'**
  String get notificationTypeFine;

  /// No description provided for @notificationTypePayment.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get notificationTypePayment;

  /// No description provided for @notificationTypeSystem.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống'**
  String get notificationTypeSystem;

  /// No description provided for @notificationTypeUnknown.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get notificationTypeUnknown;

  /// No description provided for @books.
  ///
  /// In vi, this message translates to:
  /// **'Sách'**
  String get books;

  /// No description provided for @fines.
  ///
  /// In vi, this message translates to:
  /// **'Tiền phạt'**
  String get fines;

  /// No description provided for @booksScreenPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Màn hình Sách - BS-APP-12'**
  String get booksScreenPlaceholder;

  /// No description provided for @finesScreenPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Màn hình Tiền phạt - Task sau'**
  String get finesScreenPlaceholder;

  /// No description provided for @borrowingOverview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan mượn sách'**
  String get borrowingOverview;

  /// No description provided for @activeBorrows.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu đang mượn'**
  String get activeBorrows;

  /// No description provided for @overdueBorrows.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu quá hạn'**
  String get overdueBorrows;

  /// No description provided for @unpaidFines.
  ///
  /// In vi, this message translates to:
  /// **'Tiền phạt chưa thanh toán'**
  String get unpaidFines;

  /// No description provided for @currentlyBorrowedBooks.
  ///
  /// In vi, this message translates to:
  /// **'Sách đang mượn'**
  String get currentlyBorrowedBooks;

  /// No description provided for @latestNotification.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo mới nhất'**
  String get latestNotification;

  /// No description provided for @mockLatestNotification.
  ///
  /// In vi, this message translates to:
  /// **'Sách Clean Code sắp đến hạn trả.'**
  String get mockLatestNotification;

  /// No description provided for @viewBooks.
  ///
  /// In vi, this message translates to:
  /// **'Xem sách'**
  String get viewBooks;

  /// No description provided for @viewBorrows.
  ///
  /// In vi, this message translates to:
  /// **'Xem phiếu mượn'**
  String get viewBorrows;

  /// No description provided for @viewFines.
  ///
  /// In vi, this message translates to:
  /// **'Xem tiền phạt'**
  String get viewFines;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có hoạt động mượn sách.'**
  String get homeEmptyTitle;

  /// No description provided for @hello.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào'**
  String get hello;

  /// No description provided for @reader.
  ///
  /// In vi, this message translates to:
  /// **'Độc giả'**
  String get reader;

  /// No description provided for @welcomeBackToBookSphere.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng bạn trở lại BookSphere'**
  String get welcomeBackToBookSphere;

  /// No description provided for @searchBooks.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm sách...'**
  String get searchBooks;

  /// No description provided for @clearSearch.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tìm kiếm'**
  String get clearSearch;

  /// No description provided for @searchFuturePlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng tìm kiếm sẽ được triển khai trong task sau.'**
  String get searchFuturePlaceholder;

  /// No description provided for @featuredBooks.
  ///
  /// In vi, this message translates to:
  /// **'Sách nổi bật'**
  String get featuredBooks;

  /// No description provided for @recommendedForYou.
  ///
  /// In vi, this message translates to:
  /// **'Đề xuất cho bạn'**
  String get recommendedForYou;

  /// No description provided for @categoryProgramming.
  ///
  /// In vi, this message translates to:
  /// **'Lập trình'**
  String get categoryProgramming;

  /// No description provided for @categoryNovel.
  ///
  /// In vi, this message translates to:
  /// **'Tiểu thuyết'**
  String get categoryNovel;

  /// No description provided for @categoryScience.
  ///
  /// In vi, this message translates to:
  /// **'Khoa học'**
  String get categoryScience;

  /// No description provided for @categoryHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get categoryHistory;

  /// No description provided for @categoryTechnology.
  ///
  /// In vi, this message translates to:
  /// **'Công nghệ'**
  String get categoryTechnology;

  /// No description provided for @appName.
  ///
  /// In vi, this message translates to:
  /// **'BookSphere'**
  String get appName;

  /// No description provided for @welcomeBack.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng trở lại'**
  String get welcomeBack;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @username.
  ///
  /// In vi, this message translates to:
  /// **'Tên đăng nhập'**
  String get username;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @showPassword.
  ///
  /// In vi, this message translates to:
  /// **'Hiện mật khẩu'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In vi, this message translates to:
  /// **'Ẩn mật khẩu'**
  String get hidePassword;

  /// No description provided for @checkingSession.
  ///
  /// In vi, this message translates to:
  /// **'Đang kiểm tra phiên đăng nhập...'**
  String get checkingSession;

  /// No description provided for @theme.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @selectTheme.
  ///
  /// In vi, this message translates to:
  /// **'Chọn giao diện'**
  String get selectTheme;

  /// No description provided for @selectLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get selectLanguage;

  /// No description provided for @lightMode.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get darkMode;

  /// No description provided for @systemMode.
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get systemMode;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Anh'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Nhật'**
  String get japanese;

  /// No description provided for @invalidCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Tên đăng nhập hoặc mật khẩu không đúng.'**
  String get invalidCredentials;

  /// No description provided for @accountInactive.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản đã bị khóa hoặc chưa được kích hoạt.'**
  String get accountInactive;

  /// No description provided for @networkError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng hoặc API Gateway.'**
  String get networkError;

  /// No description provided for @serverUnavailable.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống tạm thời không khả dụng. Vui lòng thử lại sau.'**
  String get serverUnavailable;

  /// No description provided for @unknownError.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi không xác định. Vui lòng thử lại.'**
  String get unknownError;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @mainScreenPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Màn hình chính sẽ được triển khai trong BS-APP-10'**
  String get mainScreenPlaceholder;

  /// No description provided for @registerScreenPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản BookSphere mới'**
  String get registerScreenPlaceholder;

  /// No description provided for @usernameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên đăng nhập.'**
  String get usernameRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu.'**
  String get passwordRequired;

  /// No description provided for @loginFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đăng nhập. Vui lòng thử lại.'**
  String get loginFailed;

  /// No description provided for @createAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get createAccount;

  /// No description provided for @fullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get phone;

  /// No description provided for @confirmPassword.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get confirmPassword;

  /// No description provided for @register.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get register;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã có tài khoản?'**
  String get alreadyHaveAccount;

  /// No description provided for @goToLogin.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get goToLogin;

  /// No description provided for @registerSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thành công. Vui lòng đăng nhập.'**
  String get registerSuccess;

  /// No description provided for @usernameDuplicated.
  ///
  /// In vi, this message translates to:
  /// **'Tên đăng nhập đã tồn tại.'**
  String get usernameDuplicated;

  /// No description provided for @emailDuplicated.
  ///
  /// In vi, this message translates to:
  /// **'Email đã được sử dụng.'**
  String get emailDuplicated;

  /// No description provided for @invalidEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ.'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại không hợp lệ.'**
  String get invalidPhone;

  /// No description provided for @passwordMinLength.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải có ít nhất 6 ký tự.'**
  String get passwordMinLength;

  /// No description provided for @confirmPasswordNotMatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu xác nhận không khớp.'**
  String get confirmPasswordNotMatch;

  /// No description provided for @requiredField.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập thông tin này.'**
  String get requiredField;

  /// No description provided for @fullNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập họ và tên.'**
  String get fullNameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email.'**
  String get emailRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số điện thoại.'**
  String get phoneRequired;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng xác nhận mật khẩu.'**
  String get confirmPasswordRequired;

  /// No description provided for @invalidRegistrationData.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu đăng ký không hợp lệ. Vui lòng kiểm tra lại.'**
  String get invalidRegistrationData;

  /// No description provided for @registrationConflict.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin đăng ký đã tồn tại.'**
  String get registrationConflict;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận đăng xuất'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn đăng xuất không?'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @logoutSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã đăng xuất.'**
  String get logoutSuccess;

  /// No description provided for @logoutFailedButCleared.
  ///
  /// In vi, this message translates to:
  /// **'Không thể kết nối máy chủ, nhưng bạn đã được đăng xuất khỏi thiết bị này.'**
  String get logoutFailedButCleared;

  /// No description provided for @home.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home;

  /// No description provided for @categories.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get categories;

  /// No description provided for @myBorrow.
  ///
  /// In vi, this message translates to:
  /// **'Sách đang mượn'**
  String get myBorrow;

  /// No description provided for @notifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifications;

  /// No description provided for @profile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profile;

  /// No description provided for @homeScreenPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Màn hình Trang chủ - BS-APP-11'**
  String get homeScreenPlaceholder;

  /// No description provided for @categoryScreenPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Màn hình Danh mục - BS-APP-13'**
  String get categoryScreenPlaceholder;

  /// No description provided for @borrowScreenPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Màn hình Mượn sách - BS-APP-14'**
  String get borrowScreenPlaceholder;

  /// No description provided for @notificationScreenPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Màn hình Thông báo - BS-APP-15'**
  String get notificationScreenPlaceholder;

  /// No description provided for @profileScreenPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Màn hình Hồ sơ - BS-APP-16'**
  String get profileScreenPlaceholder;

  /// No description provided for @borrowBook.
  ///
  /// In vi, this message translates to:
  /// **'Mượn sách'**
  String get borrowBook;

  /// No description provided for @bookInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin sách'**
  String get bookInfo;

  /// No description provided for @quantity.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng'**
  String get quantity;

  /// No description provided for @dueDate.
  ///
  /// In vi, this message translates to:
  /// **'Hạn trả'**
  String get dueDate;

  /// No description provided for @selectDueDate.
  ///
  /// In vi, this message translates to:
  /// **'Chọn hạn trả sách'**
  String get selectDueDate;

  /// No description provided for @confirmBorrowTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mượn sách'**
  String get confirmBorrowTitle;

  /// No description provided for @confirmBorrowMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn mượn {quantity} cuốn \'{title}\' đến ngày {date} không?'**
  String confirmBorrowMessage(int quantity, String title, String date);

  /// No description provided for @borrowSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký mượn sách thành công!'**
  String get borrowSuccess;

  /// No description provided for @bookOutOfStock.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng sách yêu cầu không còn đủ.'**
  String get bookOutOfStock;

  /// No description provided for @bookInactive.
  ///
  /// In vi, this message translates to:
  /// **'Sách này hiện không khả dụng.'**
  String get bookInactive;

  /// No description provided for @borrowSagaFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tạo yêu cầu mượn sách. Vui lòng thử lại.'**
  String get borrowSagaFailed;

  /// No description provided for @quantityRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số lượng.'**
  String get quantityRequired;

  /// No description provided for @quantityInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số nguyên lớn hơn 0.'**
  String get quantityInvalid;

  /// No description provided for @quantityExceeded.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng không được vượt quá tồn kho khả dụng.'**
  String get quantityExceeded;

  /// No description provided for @dueDateRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn hạn trả.'**
  String get dueDateRequired;

  /// No description provided for @dueDateInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Hạn trả phải ở tương lai.'**
  String get dueDateInvalid;

  /// No description provided for @noBorrowRecords.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có phiếu mượn sách nào.'**
  String get noBorrowRecords;

  /// No description provided for @statusAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get statusAll;

  /// No description provided for @statusBorrowing.
  ///
  /// In vi, this message translates to:
  /// **'Đang mượn'**
  String get statusBorrowing;

  /// No description provided for @statusOverdue.
  ///
  /// In vi, this message translates to:
  /// **'Quá hạn'**
  String get statusOverdue;

  /// No description provided for @statusReturned.
  ///
  /// In vi, this message translates to:
  /// **'Đã trả'**
  String get statusReturned;

  /// No description provided for @statusCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy'**
  String get statusCancelled;

  /// No description provided for @borrowDetails.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết mượn sách'**
  String get borrowDetails;

  /// No description provided for @overdueWarning.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu mượn này đã quá hạn!'**
  String get overdueWarning;

  /// No description provided for @returnBook.
  ///
  /// In vi, this message translates to:
  /// **'Trả sách'**
  String get returnBook;

  /// No description provided for @confirmReturnTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận trả sách'**
  String get confirmReturnTitle;

  /// No description provided for @confirmReturnMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn trả sách cho phiếu mượn này không?'**
  String get confirmReturnMessage;

  /// No description provided for @returnSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Trả sách thành công!'**
  String get returnSuccess;

  /// No description provided for @borrowAlreadyReturned.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu mượn này đã được trả sách.'**
  String get borrowAlreadyReturned;

  /// No description provided for @borrowNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thông tin phiếu mượn.'**
  String get borrowNotFound;

  /// No description provided for @borrowNotAllowed.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không có quyền trả sách cho phiếu mượn này.'**
  String get borrowNotAllowed;

  /// No description provided for @overdueReturnWarning.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu mượn này đã quá hạn. Việc trả sách có thể phát sinh phí phạt.'**
  String get overdueReturnWarning;

  /// No description provided for @myFines.
  ///
  /// In vi, this message translates to:
  /// **'Tiền phạt của tôi'**
  String get myFines;

  /// No description provided for @loadFinesFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách tiền phạt.'**
  String get loadFinesFailed;

  /// No description provided for @noFinesFound.
  ///
  /// In vi, this message translates to:
  /// **'Không có tiền phạt nào.'**
  String get noFinesFound;

  /// No description provided for @fineStatusAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get fineStatusAll;

  /// No description provided for @fineStatusUnpaid.
  ///
  /// In vi, this message translates to:
  /// **'Chưa thanh toán'**
  String get fineStatusUnpaid;

  /// No description provided for @fineStatusPaid.
  ///
  /// In vi, this message translates to:
  /// **'Đã thanh toán'**
  String get fineStatusPaid;

  /// No description provided for @fineStatusCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy'**
  String get fineStatusCancelled;

  /// No description provided for @fineDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết tiền phạt'**
  String get fineDetail;

  /// No description provided for @fineId.
  ///
  /// In vi, this message translates to:
  /// **'Mã phạt #'**
  String get fineId;

  /// No description provided for @borrowId.
  ///
  /// In vi, this message translates to:
  /// **'Mã phiếu mượn'**
  String get borrowId;

  /// No description provided for @reason.
  ///
  /// In vi, this message translates to:
  /// **'Lý do'**
  String get reason;

  /// No description provided for @createdFrom.
  ///
  /// In vi, this message translates to:
  /// **'Nguồn tạo'**
  String get createdFrom;

  /// No description provided for @createdAt.
  ///
  /// In vi, this message translates to:
  /// **'Ngày tạo'**
  String get createdAt;

  /// No description provided for @paidAt.
  ///
  /// In vi, this message translates to:
  /// **'Ngày thanh toán'**
  String get paidAt;

  /// No description provided for @payFine.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền phạt'**
  String get payFine;

  /// No description provided for @payNow.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán ngay'**
  String get payNow;

  /// No description provided for @cash.
  ///
  /// In vi, this message translates to:
  /// **'Tiền mặt'**
  String get cash;

  /// No description provided for @bankTransfer.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển khoản'**
  String get bankTransfer;

  /// No description provided for @eWallet.
  ///
  /// In vi, this message translates to:
  /// **'Ví điện tử'**
  String get eWallet;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In vi, this message translates to:
  /// **'Chọn phương thức thanh toán'**
  String get selectPaymentMethod;

  /// No description provided for @confirmSelection.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirmSelection;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @searchByTitleAuthorIsbn.
  ///
  /// In vi, this message translates to:
  /// **'Tìm theo tên sách, tác giả hoặc ISBN'**
  String get searchByTitleAuthorIsbn;

  /// No description provided for @allCategories.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả thể loại'**
  String get allCategories;

  /// No description provided for @allAvailability.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get allAvailability;

  /// No description provided for @available.
  ///
  /// In vi, this message translates to:
  /// **'Còn sách'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In vi, this message translates to:
  /// **'Hết sách'**
  String get unavailable;

  /// No description provided for @availableOnly.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ sách còn sẵn'**
  String get availableOnly;

  /// No description provided for @copiesAvailable.
  ///
  /// In vi, this message translates to:
  /// **'Còn {count} bản'**
  String copiesAvailable(int count);

  /// No description provided for @noBooks.
  ///
  /// In vi, this message translates to:
  /// **'Thư viện chưa có sách nào.'**
  String get noBooks;

  /// No description provided for @noBooksFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy sách phù hợp với tìm kiếm hoặc bộ lọc.'**
  String get noBooksFound;

  /// No description provided for @clearFilters.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bộ lọc'**
  String get clearFilters;

  /// No description provided for @loadBooksFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách sách.'**
  String get loadBooksFailed;

  /// No description provided for @checkConnectionAndRetry.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng kiểm tra kết nối và thử lại.'**
  String get checkConnectionAndRetry;

  /// No description provided for @loadingMore.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải thêm...'**
  String get loadingMore;

  /// No description provided for @unknownAuthor.
  ///
  /// In vi, this message translates to:
  /// **'Chưa rõ tác giả'**
  String get unknownAuthor;

  /// No description provided for @unknownCategory.
  ///
  /// In vi, this message translates to:
  /// **'Chưa phân loại'**
  String get unknownCategory;

  /// No description provided for @accessDenied.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không có quyền xem nội dung này.'**
  String get accessDenied;

  /// No description provided for @bookDetails.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết sách'**
  String get bookDetails;

  /// No description provided for @author.
  ///
  /// In vi, this message translates to:
  /// **'Tác giả'**
  String get author;

  /// No description provided for @category.
  ///
  /// In vi, this message translates to:
  /// **'Thể loại'**
  String get category;

  /// No description provided for @isbn.
  ///
  /// In vi, this message translates to:
  /// **'ISBN'**
  String get isbn;

  /// No description provided for @publisher.
  ///
  /// In vi, this message translates to:
  /// **'Nhà xuất bản'**
  String get publisher;

  /// No description provided for @publicationYear.
  ///
  /// In vi, this message translates to:
  /// **'Năm xuất bản'**
  String get publicationYear;

  /// No description provided for @description.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả'**
  String get description;

  /// No description provided for @totalCopies.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số bản'**
  String get totalCopies;

  /// No description provided for @availableCopies.
  ///
  /// In vi, this message translates to:
  /// **'Số bản còn lại'**
  String get availableCopies;

  /// No description provided for @copiesAvailableOfTotal.
  ///
  /// In vi, this message translates to:
  /// **'Còn {available} / {total} bản'**
  String copiesAvailableOfTotal(int available, int total);

  /// No description provided for @bookNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy sách.'**
  String get bookNotFound;

  /// No description provided for @bookNotFoundDescription.
  ///
  /// In vi, this message translates to:
  /// **'Sách có thể đã bị xóa hoặc không còn khả dụng.'**
  String get bookNotFoundDescription;

  /// No description provided for @loadBookDetailFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải chi tiết sách.'**
  String get loadBookDetailFailed;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có mô tả.'**
  String get noDescriptionAvailable;

  /// No description provided for @backToBooks.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại danh sách sách'**
  String get backToBooks;

  /// No description provided for @filters.
  ///
  /// In vi, this message translates to:
  /// **'Bộ lọc'**
  String get filters;

  /// No description provided for @applyFilters.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get applyFilters;

  /// No description provided for @resetFilters.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại'**
  String get resetFilters;

  /// No description provided for @clearAll.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tất cả'**
  String get clearAll;

  /// No description provided for @selectCategory.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thể loại'**
  String get selectCategory;

  /// No description provided for @availability.
  ///
  /// In vi, this message translates to:
  /// **'Tình trạng còn sách'**
  String get availability;

  /// No description provided for @activeFilters.
  ///
  /// In vi, this message translates to:
  /// **'Bộ lọc đang áp dụng'**
  String get activeFilters;

  /// No description provided for @noSearchResults.
  ///
  /// In vi, this message translates to:
  /// **'Không có sách khớp với tìm kiếm của bạn.'**
  String get noSearchResults;

  /// No description provided for @noFilterResults.
  ///
  /// In vi, this message translates to:
  /// **'Không có sách khớp với bộ lọc đã chọn.'**
  String get noFilterResults;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In vi, this message translates to:
  /// **'Hãy thử từ khóa khác.'**
  String get tryDifferentSearch;

  /// No description provided for @loadCategoriesFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách thể loại.'**
  String get loadCategoriesFailed;

  /// No description provided for @searchBooksFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tìm kiếm sách. Vui lòng thử lại.'**
  String get searchBooksFailed;

  /// No description provided for @apply.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get apply;

  /// No description provided for @addToBorrowList.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào danh sách mượn'**
  String get addToBorrowList;

  /// No description provided for @addedToBorrowList.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm vào danh sách mượn.'**
  String get addedToBorrowList;

  /// No description provided for @alreadyAddedToBorrowList.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm vào danh sách mượn'**
  String get alreadyAddedToBorrowList;

  /// No description provided for @alreadyInBorrowList.
  ///
  /// In vi, this message translates to:
  /// **'Sách này đã có trong danh sách mượn.'**
  String get alreadyInBorrowList;

  /// No description provided for @borrowList.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách mượn'**
  String get borrowList;

  /// No description provided for @borrowListItemCount.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =0{Chưa có sách trong danh sách mượn} =1{1 sách trong danh sách mượn} other{{count} sách trong danh sách mượn}}'**
  String borrowListItemCount(int count);

  /// No description provided for @viewBorrowList.
  ///
  /// In vi, this message translates to:
  /// **'Xem danh sách'**
  String get viewBorrowList;

  /// No description provided for @removeFromBorrowList.
  ///
  /// In vi, this message translates to:
  /// **'Xóa khỏi danh sách mượn'**
  String get removeFromBorrowList;

  /// No description provided for @removedFromBorrowList.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa khỏi danh sách mượn.'**
  String get removedFromBorrowList;

  /// No description provided for @clearBorrowList.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tất cả'**
  String get clearBorrowList;

  /// No description provided for @clearBorrowListConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xóa toàn bộ sách khỏi danh sách mượn?'**
  String get clearBorrowListConfirm;

  /// No description provided for @borrowListEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách mượn của bạn đang trống.'**
  String get borrowListEmpty;

  /// No description provided for @borrowListEmptyDescription.
  ///
  /// In vi, this message translates to:
  /// **'Thêm sách từ danh sách sách hoặc trang chi tiết sách.'**
  String get borrowListEmptyDescription;

  /// No description provided for @browseBooks.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt sách'**
  String get browseBooks;

  /// No description provided for @bookUnavailable.
  ///
  /// In vi, this message translates to:
  /// **'Sách này hiện không khả dụng.'**
  String get bookUnavailable;

  /// No description provided for @added.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm'**
  String get added;

  /// No description provided for @confirmBorrowLaterNote.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mượn sẽ được triển khai ở task sau.'**
  String get confirmBorrowLaterNote;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
