import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:civic_bridge_app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const CivicBridgeApp());

    // Verify MaterialApp exists
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
