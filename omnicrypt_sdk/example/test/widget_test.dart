// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';
import 'package:example/storage.dart';

class MockStorage implements Storage {
  final Map<String, String> _mockData = {};

  @override
  Future<String?> retrieveText(String key) async {
    return _mockData[key];
  }

  @override
  Future<bool> saveText(String key, String text) async {
    _mockData[key] = text;
    return true;
  }
}

void main() {
  late MockStorage mockStorage;

  setUp(() {
    mockStorage = MockStorage();
  });

  testWidgets('Verify initial state', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(storage: mockStorage));

    // Verify the app title
    expect(find.text('OmniCrypt Example'), findsOneWidget);

    // Verify text fields are present with correct labels
    expect(find.widgetWithText(TextField, 'Enter Key'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Enter Content'), findsOneWidget);

    // Verify buttons are present
    expect(
      find.widgetWithText(ElevatedButton, 'Encrypt & Save'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(ElevatedButton, 'Decrypt & Retrieve'),
      findsOneWidget,
    );

    // Verify no error/success messages are shown initially
    expect(find.text('Please enter a key.'), findsNothing);
    expect(find.text('Please enter content to encrypt.'), findsNothing);
    expect(
      find.text('Content encrypted and saved successfully.'),
      findsNothing,
    );
    expect(find.text('Failed to save content.'), findsNothing);
    expect(find.text('Failed to retrieve content.'), findsNothing);
  });

  testWidgets('Encrypt & Save with valid input', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(storage: mockStorage));

    // Enter key and content
    await tester.enterText(
      find.widgetWithText(TextField, 'Enter Key'),
      'test-key',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Enter Content'),
      'Hello, World!',
    );

    // Tap encrypt button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Encrypt & Save'));
    await tester.pump(); // Trigger rebuild

    // Verify success message
    expect(
      find.text('Content encrypted and saved successfully.'),
      findsOneWidget,
    );

    // Verify fields are cleared (controllers should be empty)
    final keyField = find.widgetWithText(TextField, 'Enter Key');
    final contentField = find.widgetWithText(TextField, 'Enter Content');
    expect(tester.widget<TextField>(keyField).controller?.text, '');
    expect(tester.widget<TextField>(contentField).controller?.text, '');
  });

  testWidgets('Encrypt & Save with empty key shows error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(storage: mockStorage));

    // Enter only content, leave key empty
    await tester.enterText(
      find.widgetWithText(TextField, 'Enter Content'),
      'Hello, World!',
    );

    // Tap encrypt button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Encrypt & Save'));
    await tester.pump();

    // Verify error message
    expect(find.text('Please enter a key.'), findsOneWidget);
  });

  testWidgets('Encrypt & Save with empty content shows error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(storage: mockStorage));

    // Enter only key, leave content empty
    await tester.enterText(
      find.widgetWithText(TextField, 'Enter Key'),
      'test-key',
    );

    // Tap encrypt button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Encrypt & Save'));
    await tester.pump();

    // Verify error message
    expect(find.text('Please enter content to encrypt.'), findsOneWidget);
  });

  testWidgets('Decrypt & Retrieve with valid key', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(storage: mockStorage));

    // First save some content
    await tester.enterText(
      find.widgetWithText(TextField, 'Enter Key'),
      'test-key',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Enter Content'),
      'Secret message',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Encrypt & Save'));
    await tester.pump();

    // Now try to retrieve it
    await tester.enterText(
      find.widgetWithText(TextField, 'Enter Key'),
      'test-key',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Decrypt & Retrieve'));
    await tester.pump();

    // Verify retrieved content is shown in the message area
    expect(find.text('Secret message'), findsOneWidget);
  });

  testWidgets('Decrypt & Retrieve with empty key shows error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(storage: mockStorage));

    // Tap decrypt button without entering key
    await tester.tap(find.widgetWithText(ElevatedButton, 'Decrypt & Retrieve'));
    await tester.pump();

    // Verify error message
    expect(find.text('Please enter a key.'), findsOneWidget);
  });

  testWidgets('Decrypt & Retrieve with non-existent key', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(storage: mockStorage));

    // Enter a key that doesn't exist
    await tester.enterText(
      find.widgetWithText(TextField, 'Enter Key'),
      'non-existent-key',
    );

    // Tap decrypt button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Decrypt & Retrieve'));
    await tester.pump();

    // Verify failure message
    expect(find.text('Failed to retrieve content.'), findsOneWidget);
  });
}
