import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:longswipe/longswipe.dart';

void main() {
  group('LongswipeWidget', () {
    testWidgets('renders default button when no child is provided',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LongswipeWidget(
              apiKey: 'test-api-key',
              referenceId: 'test-reference-id',
              environment: Environment.sandbox,
              onResponse: (type, data) {},
            ),
          ),
        ),
      );

      // Verify that the default button is rendered
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Pay with Longswipe'), findsOneWidget);
    });

    testWidgets('renders custom button text when buttonText is provided',
        (WidgetTester tester) async {
      // Build the widget with custom button text
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LongswipeWidget(
              apiKey: 'test-api-key',
              referenceId: 'test-reference-id',
              environment: Environment.sandbox,
              onResponse: (type, data) {},
              buttonText: 'Custom Text',
            ),
          ),
        ),
      );

      // Verify that the button with custom text is rendered
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Custom Text'), findsOneWidget);
    });

    testWidgets('renders child widget when provided',
        (WidgetTester tester) async {
      // Build the widget with a child
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LongswipeWidget(
              apiKey: 'test-api-key',
              referenceId: 'test-reference-id',
              environment: Environment.sandbox,
              onResponse: (type, data) {},
              child: const Text('Custom Widget'),
            ),
          ),
        ),
      );

      // Verify that the child widget is rendered
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text('Custom Widget'), findsOneWidget);
    });
  });

  group('LongswipeController', () {
    test('initializes with correct options', () {
      // Create controller
      final controller = LongswipeController(
        options: LongswipeControllerOptions(
          apiKey: 'test-api-key',
          referenceId: 'test-reference-id',
          environment: Environment.sandbox,
          onResponse: (type, data) {},
          defaultCurrency: Currency.USDT,
          defaultAmount: 100,
        ),
      );

      // Verify controller properties
      expect(controller.isLoaded, false);
      expect(controller.isLoading, false);
    });
  });

  // Note: We can't test the WebView functionality in widget tests
  // as it requires a real device or emulator with camera permissions.
  // For those tests, you would need to write integration tests.
}
