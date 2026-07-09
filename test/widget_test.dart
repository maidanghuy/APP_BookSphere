import 'package:booksphere_app/app/app.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('starts at splash and navigates to login without tokens', (
    tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});

    await tester.pumpWidget(const BookSphereApp());
    await tester.pumpAndSettle();

    expect(
      find.text('Login Screen will be implemented in BS-APP-07'),
      findsOneWidget,
    );
  });
}
