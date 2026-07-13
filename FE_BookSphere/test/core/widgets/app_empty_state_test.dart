import 'package:booksphere_app/core/widgets/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows content and invokes action', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: AppEmptyState(
          title: 'No books',
          description: 'Pull down to refresh',
          actionLabel: 'Retry',
          onAction: () => calls++,
        ),
      ),
    );

    expect(find.text('No books'), findsOneWidget);
    expect(find.text('Pull down to refresh'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    expect(calls, 1);
  });
}
