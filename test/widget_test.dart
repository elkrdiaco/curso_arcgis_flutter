// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:curso_arcgis_flutter/main.dart';

void main() {
  testWidgets('Smoke test: App starts without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // If your main app widget is not named 'MyApp', please change it here.
    await tester.pumpWidget(const MainApp());

    // A basic test can simply verify that the app doesn't throw an error during build.
    // For a more robust test, you would verify that a specific widget is visible.
    // For example: expect(find.text('Hello World'), findsOneWidget);
  });
}