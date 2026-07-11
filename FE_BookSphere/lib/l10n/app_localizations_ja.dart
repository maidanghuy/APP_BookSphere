// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get notificationListTitle => '通知';

  @override
  String get allNotifications => 'すべて';

  @override
  String get unreadNotifications => '未読';

  @override
  String get noNotifications => '通知はまだありません';

  @override
  String get noUnreadNotifications => '未読の通知はありません';

  @override
  String get markAsReadFailed => '通知を既読にできませんでした。';

  @override
  String get notificationTypeBorrow => '貸出';

  @override
  String get notificationTypeReturn => '返却';

  @override
  String get notificationTypeDueSoon => '返却期限間近';

  @override
  String get notificationTypeOverdue => '延滞';

  @override
  String get notificationTypeFine => '罰金';

  @override
  String get notificationTypePayment => '支払い';

  @override
  String get notificationTypeSystem => 'システム';

  @override
  String get notificationTypeUnknown => 'その他';

  @override
  String get books => '本';

  @override
  String get fines => '罰金';

  @override
  String get booksScreenPlaceholder => '本の画面 - BS-APP-12';

  @override
  String get finesScreenPlaceholder => '罰金画面 - 今後のタスク';

  @override
  String get borrowingOverview => '貸出状況';

  @override
  String get activeBorrows => '貸出中';

  @override
  String get overdueBorrows => '延滞中';

  @override
  String get unpaidFines => '未払いの罰金';

  @override
  String get currentlyBorrowedBooks => '現在借りている本';

  @override
  String get latestNotification => '最新のお知らせ';

  @override
  String get mockLatestNotification => 'Clean Codeの返却期限が近づいています。';

  @override
  String get viewBooks => '本を見る';

  @override
  String get viewBorrows => '貸出票を見る';

  @override
  String get viewFines => '罰金を見る';

  @override
  String get homeEmptyTitle => '貸出履歴はまだありません。';

  @override
  String get hello => 'こんにちは';

  @override
  String get reader => '読者';

  @override
  String get welcomeBackToBookSphere => 'BookSphereへようこそ';

  @override
  String get searchBooks => '本を検索...';

  @override
  String get clearSearch => '検索をクリア';

  @override
  String get searchFuturePlaceholder => '検索機能は今後のタスクで実装されます。';

  @override
  String get featuredBooks => '注目の本';

  @override
  String get recommendedForYou => 'あなたへのおすすめ';

  @override
  String get categoryProgramming => 'プログラミング';

  @override
  String get categoryNovel => '小説';

  @override
  String get categoryScience => '科学';

  @override
  String get categoryHistory => '歴史';

  @override
  String get categoryTechnology => 'テクノロジー';

  @override
  String get appName => 'BookSphere';

  @override
  String get welcomeBack => 'おかえりなさい';

  @override
  String get login => 'ログイン';

  @override
  String get username => 'ユーザー名';

  @override
  String get password => 'パスワード';

  @override
  String get showPassword => 'パスワードを表示';

  @override
  String get hidePassword => 'パスワードを非表示';

  @override
  String get checkingSession => 'セッションを確認しています...';

  @override
  String get theme => 'テーマ';

  @override
  String get language => '言語';

  @override
  String get selectTheme => 'テーマを選択';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get lightMode => 'ライト';

  @override
  String get darkMode => 'ダーク';

  @override
  String get systemMode => 'システム設定';

  @override
  String get vietnamese => 'ベトナム語';

  @override
  String get english => '英語';

  @override
  String get japanese => '日本語';

  @override
  String get invalidCredentials => 'ユーザー名またはパスワードが正しくありません。';

  @override
  String get accountInactive => 'アカウントがロックされているか、有効化されていません。';

  @override
  String get networkError => 'サーバーに接続できません。ネットワークまたはAPIゲートウェイを確認してください。';

  @override
  String get serverUnavailable => 'システムは一時的に利用できません。後でもう一度お試しください。';

  @override
  String get unknownError => '不明なエラーが発生しました。もう一度お試しください。';

  @override
  String get retry => '再試行';

  @override
  String get mainScreenPlaceholder => 'メイン画面はBS-APP-10で実装されます';

  @override
  String get registerScreenPlaceholder => 'BookSphereの新しいアカウントを作成';

  @override
  String get usernameRequired => 'ユーザー名を入力してください。';

  @override
  String get passwordRequired => 'パスワードを入力してください。';

  @override
  String get loginFailed => 'ログインできません。もう一度お試しください。';

  @override
  String get createAccount => 'アカウントを作成';

  @override
  String get fullName => '氏名';

  @override
  String get email => 'メール';

  @override
  String get phone => '電話番号';

  @override
  String get confirmPassword => 'パスワード確認';

  @override
  String get register => '登録';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get goToLogin => 'ログイン';

  @override
  String get registerSuccess => '登録が完了しました。ログインしてください。';

  @override
  String get usernameDuplicated => 'このユーザー名はすでに存在します。';

  @override
  String get emailDuplicated => 'このメールはすでに使用されています。';

  @override
  String get invalidEmail => '有効なメールアドレスを入力してください。';

  @override
  String get invalidPhone => '有効な電話番号を入力してください。';

  @override
  String get passwordMinLength => 'パスワードは6文字以上で入力してください。';

  @override
  String get confirmPasswordNotMatch => '確認用パスワードが一致しません。';

  @override
  String get requiredField => 'この項目を入力してください。';

  @override
  String get fullNameRequired => '氏名を入力してください。';

  @override
  String get emailRequired => 'メールを入力してください。';

  @override
  String get phoneRequired => '電話番号を入力してください。';

  @override
  String get confirmPasswordRequired => 'パスワード確認を入力してください。';

  @override
  String get invalidRegistrationData => '登録データが無効です。もう一度確認してください。';

  @override
  String get registrationConflict => '登録情報はすでに存在します。';

  @override
  String get logout => 'ログアウト';

  @override
  String get logoutConfirmTitle => 'ログアウト確認';

  @override
  String get logoutConfirmMessage => 'ログアウトしてもよろしいですか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get logoutSuccess => 'ログアウトしました。';

  @override
  String get logoutFailedButCleared => 'サーバーに接続できませんでしたが、この端末からはログアウトしました。';

  @override
  String get home => 'ホーム';

  @override
  String get categories => 'カテゴリー';

  @override
  String get myBorrow => '貸出中';

  @override
  String get notifications => '通知';

  @override
  String get profile => 'プロフィール';

  @override
  String get homeScreenPlaceholder => 'ホーム画面 - BS-APP-11';

  @override
  String get categoryScreenPlaceholder => 'カテゴリー画面 - BS-APP-13';

  @override
  String get borrowScreenPlaceholder => '貸出画面 - BS-APP-14';

  @override
  String get notificationScreenPlaceholder => '通知画面 - BS-APP-15';

  @override
  String get profileScreenPlaceholder => 'プロフィール画面 - BS-APP-16';

  @override
  String get borrowBook => '本を借りる';

  @override
  String get bookInfo => '書籍情報';

  @override
  String get quantity => '数量';

  @override
  String get dueDate => '返却期限';

  @override
  String get selectDueDate => '返却期限を選択';

  @override
  String get confirmBorrowTitle => '貸出の確認';

  @override
  String confirmBorrowMessage(int quantity, String title, String date) {
    return '「$title」を $quantity 冊、$date まで借りますか？';
  }

  @override
  String get borrowSuccess => '貸出申請が正常に作成されました！';

  @override
  String get bookOutOfStock => '要求された数量はもう利用できません。';

  @override
  String get bookInactive => 'この本は現在利用できません。';

  @override
  String get borrowSagaFailed => '貸出申請を作成できません。もう一度お試しください。';

  @override
  String get quantityRequired => '数量を入力してください。';

  @override
  String get quantityInvalid => '0より大きい有効な整数を入力してください。';

  @override
  String get quantityExceeded => '数量は利用可能な在庫を超えることはできません。';

  @override
  String get dueDateRequired => '返却期限日を選択してください。';

  @override
  String get dueDateInvalid => '返却期限日は将来の日付にしてください。';

  @override
  String get noBorrowRecords => '貸出記録がありません。';

  @override
  String get statusAll => 'すべて';

  @override
  String get statusBorrowing => '貸出中';

  @override
  String get statusOverdue => '期限切れ';

  @override
  String get statusReturned => '返却済み';

  @override
  String get statusCancelled => 'キャンセル';

  @override
  String get borrowDetails => '貸出詳細';

  @override
  String get overdueWarning => 'この貸出は期限切れです。';

  @override
  String get returnBook => '本を返却する';

  @override
  String get confirmReturnTitle => '返却の確認';

  @override
  String get confirmReturnMessage => 'この貸出申請の本を返却しますか？';

  @override
  String get returnSuccess => '本が正常に返却されました！';

  @override
  String get borrowAlreadyReturned => 'この貸出はすでに返却されています。';

  @override
  String get borrowNotFound => '貸出記録が見つかりません。';

  @override
  String get borrowNotAllowed => 'この貸出の返却は許可されていません。';

  @override
  String get overdueReturnWarning => 'この貸出は期限切れです。本を返却すると罰金が発生する可能性があります。';

  @override
  String get searchByTitleAuthorIsbn => 'タイトル・著者・ISBNで検索';

  @override
  String get allCategories => 'すべてのカテゴリ';

  @override
  String get allAvailability => 'すべて';

  @override
  String get available => '貸出可能';

  @override
  String get unavailable => '貸出不可';

  @override
  String get availableOnly => '貸出可能な本のみ';

  @override
  String copiesAvailable(int count) {
    return '残り$count冊';
  }

  @override
  String get noBooks => 'まだ本が登録されていません。';

  @override
  String get noBooksFound => '検索条件やフィルターに一致する本がありません。';

  @override
  String get clearFilters => 'フィルターをクリア';

  @override
  String get loadBooksFailed => '本の一覧を読み込めませんでした。';

  @override
  String get checkConnectionAndRetry => '接続を確認して、もう一度お試しください。';

  @override
  String get loadingMore => 'さらに読み込み中...';

  @override
  String get unknownAuthor => '著者不明';

  @override
  String get unknownCategory => '未分類';

  @override
  String get accessDenied => 'このコンテンツを表示する権限がありません。';

  @override
  String get bookDetails => '本の詳細';

  @override
  String get author => '著者';

  @override
  String get category => 'カテゴリ';

  @override
  String get isbn => 'ISBN';

  @override
  String get publisher => '出版社';

  @override
  String get publicationYear => '出版年';

  @override
  String get description => '説明';

  @override
  String get totalCopies => '総冊数';

  @override
  String get availableCopies => '貸出可能数';

  @override
  String copiesAvailableOfTotal(int available, int total) {
    return '残り $available / $total 冊';
  }

  @override
  String get bookNotFound => '本が見つかりません。';

  @override
  String get bookNotFoundDescription => '本が削除されたか、現在利用できない可能性があります。';

  @override
  String get loadBookDetailFailed => '本の詳細を読み込めませんでした。';

  @override
  String get noDescriptionAvailable => '説明はありません。';

  @override
  String get backToBooks => '本の一覧に戻る';

  @override
  String get filters => 'フィルター';

  @override
  String get applyFilters => '適用';

  @override
  String get resetFilters => 'リセット';

  @override
  String get clearAll => 'すべてクリア';

  @override
  String get selectCategory => 'カテゴリを選択';

  @override
  String get availability => '貸出状況';

  @override
  String get activeFilters => '適用中のフィルター';

  @override
  String get noSearchResults => '検索条件に一致する本がありません。';

  @override
  String get noFilterResults => '選択したフィルターに一致する本がありません。';

  @override
  String get tryDifferentSearch => '別のキーワードを試してください。';

  @override
  String get loadCategoriesFailed => 'カテゴリを読み込めませんでした。';

  @override
  String get searchBooksFailed => '本を検索できませんでした。もう一度お試しください。';

  @override
  String get apply => '適用';
}
