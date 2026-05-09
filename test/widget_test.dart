// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:propertylisting/main.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:propertylisting/core/storage/local_storage_service.dart';

void main() {
  testWidgets('MainApp smoke test', (WidgetTester tester) async {
    // We need to mock SharedPreferences for the test
    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
        child: const MainApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Placeholder for Home / Listing List'), findsOneWidget);
  });
}

