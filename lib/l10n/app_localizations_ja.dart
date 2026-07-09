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
  String get registerScreenPlaceholder => '登録画面はBS-APP-08で実装されます';

  @override
  String get usernameRequired => 'ユーザー名を入力してください。';

  @override
  String get passwordRequired => 'パスワードを入力してください。';

  @override
  String get loginFailed => 'ログインできません。もう一度お試しください。';
}
