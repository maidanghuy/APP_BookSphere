import 'package:booksphere_app/core/widgets/app_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('loading disables callback and shows progress', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: AppLoadingButton(
          label: 'Submit',
          isLoading: true,
          onPressed: () => calls++,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    expect(calls, 0);
  });

  testWidgets('not loading invokes callback once', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: AppLoadingButton(label: 'Submit', onPressed: () => calls++),
      ),
    );

    await tester.tap(find.byType(FilledButton));
    expect(calls, 1);
  });
}
