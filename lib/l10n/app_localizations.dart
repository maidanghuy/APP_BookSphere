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
