import 'package:booksphere_app/core/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows progress and optional message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AppLoading(message: 'Loading data')),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading data'), findsOneWidget);
  });
}
