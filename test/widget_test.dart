// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:Leafcure/pages/how_to_use_page.dart';

void main() {
  testWidgets('HowToUsePage renders the guide sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HowToUsePage()));

    expect(find.text('How to Use Leafcure'), findsOneWidget);
    expect(find.text('Use Leafcure in 4 easy steps'), findsOneWidget);
    expect(find.text('Main buttons and what they do'), findsOneWidget);
    expect(
      find.text(
        'If the phone asks for camera access, tap Allow. You only need to do this once.',
      ),
      findsOneWidget,
    );
  });
}
