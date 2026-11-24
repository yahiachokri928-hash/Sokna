import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/strings/messages.dart';
import 'package:sokna/core/widgets/sokna_logo.dart';

void main() {
  testWidgets('SoknaLogo renders emblem, title and arabic name in full mode', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SoknaLogo(),
        ),
      ),
    );

    expect(find.byIcon(Icons.home_work_rounded), findsOneWidget);
    expect(find.text(APP_TITLE), findsOneWidget);
    expect(find.text(APP_ARABIC_NAME), findsOneWidget);
    expect(find.text(APP_SUBTITLE), findsOneWidget);
  });

  testWidgets('SoknaLogo renders compact horizontal emblem and title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SoknaLogo(isCompact: true),
        ),
      ),
    );

    expect(find.byIcon(Icons.home_work_rounded), findsOneWidget);
    expect(find.text(APP_TITLE), findsOneWidget);
    expect(find.text(APP_ARABIC_NAME), findsOneWidget);
  });
}
