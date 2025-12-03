import 'package:flutter_test/flutter_test.dart';
import 'package:civic_bridge/main.dart';

void main() {
  testWidgets('App loads SplashScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const CivicBridgeApp());

    // Check for CivicBridge text on splash screen
    expect(find.text('CivicBridge'), findsOneWidget);
  });
}
