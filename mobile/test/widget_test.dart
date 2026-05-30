// Basic smoke test for the RuangBuku app.

import 'package:flutter_test/flutter_test.dart';

import 'package:ruangbuku/main.dart';

void main() {
  testWidgets('Theme preview screen loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RuangBukuApp());

    // Verify that the app title is displayed.
    expect(find.text('RuangBuku'), findsOneWidget);

    // Verify that theme preview sections are present.
    expect(find.text('Color Palette'), findsOneWidget);
    expect(find.text('Typography'), findsOneWidget);
    expect(find.text('Buttons'), findsOneWidget);
  });
}
