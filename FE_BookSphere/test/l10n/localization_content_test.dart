import 'package:booksphere_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Vietnamese, English and Japanese localization keeps Unicode text',
    () async {
      final vi = await AppLocalizations.delegate.load(const Locale('vi'));
      final en = await AppLocalizations.delegate.load(const Locale('en'));
      final ja = await AppLocalizations.delegate.load(const Locale('ja'));

      expect(vi.notifications, 'Thông báo');
      expect(en.notifications, 'Notifications');
      expect(ja.notifications, '通知');
      expect(vi.logout, 'Đăng xuất');
      expect(ja.logout, 'ログアウト');
    },
  );
}
