import 'package:booksphere_app/features/auth/presentation/widgets/logout_button.dart';
import 'package:booksphere_app/features/home/widgets/main_bottom_navigation.dart';
import 'package:booksphere_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) => ProviderScope(
  child: MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  ),
);

void main() {
  testWidgets('mobile navigation hides labels and shows unread badge', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _app(
        MainBottomNavigation(
          currentIndex: 4,
          unreadCount: 6,
          onDestinationSelected: (_) {},
        ),
      ),
    );

    final navigation = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(
      navigation.labelBehavior,
      NavigationDestinationLabelBehavior.alwaysHide,
    );
    expect(find.text('6'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('compact logout stays icon sized', (tester) async {
    await tester.pumpWidget(_app(const LogoutButton(compact: true)));

    expect(find.byIcon(Icons.logout), findsOneWidget);
    expect(tester.getSize(find.byType(IconButton)), const Size(48, 48));
  });
}
