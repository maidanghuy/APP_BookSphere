import 'package:booksphere_app/core/widgets/app_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere_app/l10n/app_localizations.dart';

void main() {
  testWidgets('shows mapped message and invokes retry', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: AppErrorView(message: 'Request failed', onRetry: () => calls++),
      ),
    );

    expect(find.text('Request failed'), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    expect(calls, 1);
  });
}
