import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cibei_space/app.dart';

void main() {
  testWidgets('App scaffold smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CibeiApp()));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
