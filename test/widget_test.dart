import 'package:booksphere_app/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows BS-APP-01 foundation screen', (tester) async {
    await tester.pumpWidget(const BookSphereApp());

    expect(find.text('BookSphere Mobile'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('Task:'), findsOneWidget);
    expect(find.text('BS-APP-01'), findsOneWidget);
    expect(find.text('Coder:'), findsOneWidget);
    expect(find.text('maidanghuy'), findsOneWidget);
    expect(find.text('Material 3 Ready'), findsOneWidget);
  });
}
