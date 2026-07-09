// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

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
}
