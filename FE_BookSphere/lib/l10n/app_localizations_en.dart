// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get notificationListTitle => 'Notifications';

  @override
  String get allNotifications => 'All';

  @override
  String get unreadNotifications => 'Unread';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get noUnreadNotifications => 'No unread notifications';

  @override
  String get markAsReadFailed => 'Unable to mark this notification as read.';

  @override
  String get notificationTypeBorrow => 'Borrow';

  @override
  String get notificationTypeReturn => 'Return';

  @override
  String get notificationTypeDueSoon => 'Due soon';

  @override
  String get notificationTypeOverdue => 'Overdue';

  @override
  String get notificationTypeFine => 'Fine';

  @override
  String get notificationTypePayment => 'Payment';

  @override
  String get notificationTypeSystem => 'System';

  @override
  String get notificationTypeUnknown => 'Other';

  @override
  String get books => 'Books';

  @override
  String get fines => 'Fines';

  @override
  String get booksScreenPlaceholder => 'Books Screen - BS-APP-12';

  @override
  String get finesScreenPlaceholder => 'Fines Screen - Future Task';

  @override
  String get borrowingOverview => 'Borrowing overview';

  @override
  String get activeBorrows => 'Active borrows';

  @override
  String get overdueBorrows => 'Overdue borrows';

  @override
  String get unpaidFines => 'Unpaid fines';

  @override
  String get currentlyBorrowedBooks => 'Currently borrowed books';

  @override
  String get latestNotification => 'Latest notification';

  @override
  String get mockLatestNotification =>
      'The due date for Clean Code is approaching.';

  @override
  String get viewBooks => 'View books';

  @override
  String get viewBorrows => 'View borrows';

  @override
  String get viewFines => 'View fines';

  @override
  String get homeEmptyTitle => 'You have no borrowing activity yet.';

  @override
  String get hello => 'Hello';

  @override
  String get reader => 'Reader';

  @override
  String get welcomeBackToBookSphere => 'Welcome back to BookSphere';

  @override
  String get searchBooks => 'Search books...';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get searchFuturePlaceholder =>
      'Search feature will be implemented in a future task.';

  @override
  String get featuredBooks => 'Featured Books';

  @override
  String get recommendedForYou => 'Recommended for you';

  @override
  String get categoryProgramming => 'Programming';

  @override
  String get categoryNovel => 'Novel';

  @override
  String get categoryScience => 'Science';

  @override
  String get categoryHistory => 'History';

  @override
  String get categoryTechnology => 'Technology';

  @override
  String get appName => 'BookSphere';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get login => 'Login';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get checkingSession => 'Checking session...';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get selectTheme => 'Select theme';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get lightMode => 'Light';

  @override
  String get darkMode => 'Dark';

  @override
  String get systemMode => 'System';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get japanese => 'Japanese';

  @override
  String get invalidCredentials => 'The username or password is incorrect.';

  @override
  String get accountInactive =>
      'The account is locked or has not been activated.';

  @override
  String get networkError =>
      'Unable to connect to the server. Please check your network or API Gateway.';

  @override
  String get serverUnavailable =>
      'The system is temporarily unavailable. Please try again later.';

  @override
  String get unknownError => 'An unknown error occurred. Please try again.';

  @override
  String get retry => 'Try again';

  @override
  String get mainScreenPlaceholder =>
      'Main screen will be implemented in BS-APP-10';

  @override
  String get registerScreenPlaceholder => 'Create a new BookSphere account';

  @override
  String get usernameRequired => 'Please enter your username.';

  @override
  String get passwordRequired => 'Please enter your password.';

  @override
  String get loginFailed => 'Unable to log in. Please try again.';

  @override
  String get createAccount => 'Create account';

  @override
  String get fullName => 'Full name';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get register => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get goToLogin => 'Login';

  @override
  String get registerSuccess => 'Registration successful. Please log in.';

  @override
  String get usernameDuplicated => 'The username already exists.';

  @override
  String get emailDuplicated => 'The email has already been used.';

  @override
  String get invalidEmail => 'Enter a valid email address.';

  @override
  String get invalidPhone => 'Enter a valid phone number.';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters.';

  @override
  String get confirmPasswordNotMatch => 'Confirm password does not match.';

  @override
  String get requiredField => 'Please enter this information.';

  @override
  String get fullNameRequired => 'Please enter your full name.';

  @override
  String get emailRequired => 'Please enter your email.';

  @override
  String get phoneRequired => 'Please enter your phone number.';

  @override
  String get confirmPasswordRequired => 'Please confirm your password.';

  @override
  String get invalidRegistrationData =>
      'Registration data is invalid. Please check again.';

  @override
  String get registrationConflict => 'Registration information already exists.';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Confirm logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get logoutSuccess => 'You have been logged out.';

  @override
  String get logoutFailedButCleared =>
      'Unable to contact the server, but you have been logged out from this device.';

  @override
  String get home => 'Home';

  @override
  String get categories => 'Categories';

  @override
  String get myBorrow => 'My Borrow';

  @override
  String get notifications => 'Notifications';

  @override
  String get profile => 'Profile';

  @override
  String get homeScreenPlaceholder => 'Home Screen - BS-APP-11';

  @override
  String get categoryScreenPlaceholder => 'Category Screen - BS-APP-13';

  @override
  String get borrowScreenPlaceholder => 'Borrow Screen - BS-APP-14';

  @override
  String get notificationScreenPlaceholder => 'Notification Screen - BS-APP-15';

  @override
  String get profileScreenPlaceholder => 'Profile Screen - BS-APP-16';

  @override
  String get borrowBook => 'Borrow Book';

  @override
  String get bookInfo => 'Book Information';

  @override
  String get quantity => 'Quantity';

  @override
  String get dueDate => 'Due Date';

  @override
  String get selectDueDate => 'Select due date';

  @override
  String get confirmBorrowTitle => 'Confirm Borrow';

  @override
  String confirmBorrowMessage(int quantity, String title, String date) {
    return 'Are you sure you want to borrow $quantity copy/copies of \'$title\' until $date?';
  }

  @override
  String get borrowSuccess => 'Borrow request created successfully!';

  @override
  String get bookOutOfStock => 'The requested quantity is no longer available.';

  @override
  String get bookInactive => 'This book is currently unavailable.';

  @override
  String get borrowSagaFailed =>
      'Unable to create borrow request. Please try again.';

  @override
  String get quantityRequired => 'Please enter quantity.';

  @override
  String get quantityInvalid => 'Please enter a valid integer greater than 0.';

  @override
  String get quantityExceeded => 'Quantity cannot exceed available stock.';

  @override
  String get dueDateRequired => 'Please select a due date.';

  @override
  String get dueDateInvalid => 'Due date must be in the future.';

  @override
  String get noBorrowRecords => 'You don\'t have any borrow records.';

  @override
  String get statusAll => 'All';

  @override
  String get statusBorrowing => 'Borrowing';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get statusReturned => 'Returned';

  @override
  String get statusCancelled => 'Cancelled';
}
