import 'package:flutter_test/flutter_test.dart';

import 'package:cibei_space/app.dart';

void main() {
  testWidgets('App scaffold smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CibeiApp());
    expect(find.text('Cibei Space'), findsOneWidget);
  });
}
