// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get notificationListTitle => 'Thông báo';

  @override
  String get allNotifications => 'Tất cả';

  @override
  String get unreadNotifications => 'Chưa đọc';

  @override
  String get noNotifications => 'Chưa có thông báo';

  @override
  String get noUnreadNotifications => 'Không có thông báo chưa đọc';

  @override
  String get markAsReadFailed => 'Không thể đánh dấu thông báo là đã đọc.';

  @override
  String get notificationTypeBorrow => 'Mượn sách';

  @override
  String get notificationTypeReturn => 'Trả sách';

  @override
  String get notificationTypeDueSoon => 'Sắp đến hạn';

  @override
  String get notificationTypeOverdue => 'Quá hạn';

  @override
  String get notificationTypeFine => 'Tiền phạt';

  @override
  String get notificationTypePayment => 'Thanh toán';

  @override
  String get notificationTypeSystem => 'Hệ thống';

  @override
  String get notificationTypeUnknown => 'Khác';

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

  @override
  String get borrowBook => 'Mượn sách';

  @override
  String get bookInfo => 'Thông tin sách';

  @override
  String get quantity => 'Số lượng';

  @override
  String get dueDate => 'Hạn trả';

  @override
  String get selectDueDate => 'Chọn hạn trả sách';

  @override
  String get confirmBorrowTitle => 'Xác nhận mượn sách';

  @override
  String confirmBorrowMessage(int quantity, String title, String date) {
    return 'Bạn có chắc chắn muốn mượn $quantity cuốn \'$title\' đến ngày $date không?';
  }

  @override
  String get borrowSuccess => 'Đăng ký mượn sách thành công!';

  @override
  String get bookOutOfStock => 'Số lượng sách yêu cầu không còn đủ.';

  @override
  String get bookInactive => 'Sách này hiện không khả dụng.';

  @override
  String get borrowSagaFailed =>
      'Không thể tạo yêu cầu mượn sách. Vui lòng thử lại.';

  @override
  String get quantityRequired => 'Vui lòng nhập số lượng.';

  @override
  String get quantityInvalid => 'Vui lòng nhập số nguyên lớn hơn 0.';

  @override
  String get quantityExceeded =>
      'Số lượng không được vượt quá tồn kho khả dụng.';

  @override
  String get dueDateRequired => 'Vui lòng chọn hạn trả.';

  @override
  String get dueDateInvalid => 'Hạn trả phải ở tương lai.';

  @override
  String get noBorrowRecords => 'Bạn chưa có phiếu mượn sách nào.';

  @override
  String get statusAll => 'Tất cả';

  @override
  String get statusBorrowing => 'Đang mượn';

  @override
  String get statusOverdue => 'Quá hạn';

  @override
  String get statusReturned => 'Đã trả';

  @override
  String get statusCancelled => 'Đã hủy';

  @override
  String get borrowDetails => 'Chi tiết mượn sách';

  @override
  String get overdueWarning => 'Phiếu mượn này đã quá hạn!';

  @override
  String get returnBook => 'Trả sách';

  @override
  String get confirmReturnTitle => 'Xác nhận trả sách';

  @override
  String get confirmReturnMessage =>
      'Bạn có chắc chắn muốn trả sách cho phiếu mượn này không?';

  @override
  String get returnSuccess => 'Trả sách thành công!';

  @override
  String get borrowAlreadyReturned => 'Phiếu mượn này đã được trả sách.';

  @override
  String get borrowNotFound => 'Không tìm thấy thông tin phiếu mượn.';

  @override
  String get borrowNotAllowed =>
      'Bạn không có quyền trả sách cho phiếu mượn này.';

  @override
  String get overdueReturnWarning =>
      'Phiếu mượn này đã quá hạn. Việc trả sách có thể phát sinh phí phạt.';

  @override
  String get myFines => 'Tiền phạt của tôi';

  @override
  String get loadFinesFailed => 'Không thể tải danh sách tiền phạt.';

  @override
  String get noFinesFound => 'Không có tiền phạt nào.';

  @override
  String get fineStatusAll => 'Tất cả';

  @override
  String get fineStatusUnpaid => 'Chưa thanh toán';

  @override
  String get fineStatusPaid => 'Đã thanh toán';

  @override
  String get fineStatusCancelled => 'Đã hủy';

  @override
  String get fineDetail => 'Chi tiết tiền phạt';

  @override
  String get fineId => 'Mã phạt #';

  @override
  String get borrowId => 'Mã phiếu mượn';

  @override
  String get reason => 'Lý do';

  @override
  String get createdFrom => 'Nguồn tạo';

  @override
  String get createdAt => 'Ngày tạo';

  @override
  String get paidAt => 'Ngày thanh toán';

  @override
  String get payFine => 'Thanh toán tiền phạt';

  @override
  String get payNow => 'Thanh toán ngay';

  @override
  String get cash => 'Tiền mặt';

  @override
  String get bankTransfer => 'Chuyển khoản';

  @override
  String get eWallet => 'Ví điện tử';

  @override
  String get selectPaymentMethod => 'Chọn phương thức thanh toán';

  @override
  String get confirmSelection => 'Xác nhận';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get searchByTitleAuthorIsbn => 'Tìm theo tên sách, tác giả hoặc ISBN';

  @override
  String get allCategories => 'Tất cả thể loại';

  @override
  String get allAvailability => 'Tất cả';

  @override
  String get available => 'Còn sách';

  @override
  String get unavailable => 'Hết sách';

  @override
  String get availableOnly => 'Chỉ sách còn sẵn';

  @override
  String copiesAvailable(int count) {
    return 'Còn $count bản';
  }

  @override
  String get noBooks => 'Thư viện chưa có sách nào.';

  @override
  String get noBooksFound =>
      'Không tìm thấy sách phù hợp với tìm kiếm hoặc bộ lọc.';

  @override
  String get clearFilters => 'Xóa bộ lọc';

  @override
  String get loadBooksFailed => 'Không thể tải danh sách sách.';

  @override
  String get checkConnectionAndRetry => 'Vui lòng kiểm tra kết nối và thử lại.';

  @override
  String get loadingMore => 'Đang tải thêm...';

  @override
  String get unknownAuthor => 'Chưa rõ tác giả';

  @override
  String get unknownCategory => 'Chưa phân loại';

  @override
  String get accessDenied => 'Bạn không có quyền xem nội dung này.';

  @override
  String get bookDetails => 'Chi tiết sách';

  @override
  String get author => 'Tác giả';

  @override
  String get category => 'Thể loại';

  @override
  String get isbn => 'ISBN';

  @override
  String get publisher => 'Nhà xuất bản';

  @override
  String get publicationYear => 'Năm xuất bản';

  @override
  String get description => 'Mô tả';

  @override
  String get totalCopies => 'Tổng số bản';

  @override
  String get availableCopies => 'Số bản còn lại';

  @override
  String copiesAvailableOfTotal(int available, int total) {
    return 'Còn $available / $total bản';
  }

  @override
  String get bookNotFound => 'Không tìm thấy sách.';

  @override
  String get bookNotFoundDescription =>
      'Sách có thể đã bị xóa hoặc không còn khả dụng.';

  @override
  String get loadBookDetailFailed => 'Không thể tải chi tiết sách.';

  @override
  String get noDescriptionAvailable => 'Chưa có mô tả.';

  @override
  String get backToBooks => 'Quay lại danh sách sách';

  @override
  String get filters => 'Bộ lọc';

  @override
  String get applyFilters => 'Áp dụng';

  @override
  String get resetFilters => 'Đặt lại';

  @override
  String get clearAll => 'Xóa tất cả';

  @override
  String get selectCategory => 'Chọn thể loại';

  @override
  String get availability => 'Tình trạng còn sách';

  @override
  String get activeFilters => 'Bộ lọc đang áp dụng';

  @override
  String get noSearchResults => 'Không có sách khớp với tìm kiếm của bạn.';

  @override
  String get noFilterResults => 'Không có sách khớp với bộ lọc đã chọn.';

  @override
  String get tryDifferentSearch => 'Hãy thử từ khóa khác.';

  @override
  String get loadCategoriesFailed => 'Không thể tải danh sách thể loại.';

  @override
  String get searchBooksFailed => 'Không thể tìm kiếm sách. Vui lòng thử lại.';

  @override
  String get apply => 'Áp dụng';

  @override
  String get addToBorrowList => 'Thêm vào danh sách mượn';

  @override
  String get addedToBorrowList => 'Đã thêm vào danh sách mượn.';

  @override
  String get alreadyAddedToBorrowList => 'Đã thêm vào danh sách mượn';

  @override
  String get alreadyInBorrowList => 'Sách này đã có trong danh sách mượn.';

  @override
  String get borrowList => 'Danh sách mượn';

  @override
  String borrowListItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sách trong danh sách mượn',
      one: '1 sách trong danh sách mượn',
      zero: 'Chưa có sách trong danh sách mượn',
    );
    return '$_temp0';
  }

  @override
  String get viewBorrowList => 'Xem danh sách';

  @override
  String get removeFromBorrowList => 'Xóa khỏi danh sách mượn';

  @override
  String get removedFromBorrowList => 'Đã xóa khỏi danh sách mượn.';

  @override
  String get clearBorrowList => 'Xóa tất cả';

  @override
  String get clearBorrowListConfirm => 'Xóa toàn bộ sách khỏi danh sách mượn?';

  @override
  String get borrowListEmpty => 'Danh sách mượn của bạn đang trống.';

  @override
  String get borrowListEmptyDescription =>
      'Thêm sách từ danh sách sách hoặc trang chi tiết sách.';

  @override
  String get browseBooks => 'Duyệt sách';

  @override
  String get bookUnavailable => 'Sách này hiện không khả dụng.';

  @override
  String get added => 'Đã thêm';

  @override
  String get confirmBorrowLaterNote =>
      'Xác nhận mượn sẽ được triển khai ở task sau.';
}
