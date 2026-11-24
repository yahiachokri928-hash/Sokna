import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/strings/messages.dart';
import 'package:sokna/core/widgets/guest_auth_prompt.dart';

void main() {
  testWidgets('GuestAuthPrompt in full mode renders title, subtitle, and action buttons', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GuestAuthPrompt(
            title: GUEST_SAVED_TITLE,
            subtitle: GUEST_SAVED_SUBTITLE,
            icon: Icons.favorite_border_rounded,
          ),
        ),
      ),
    );

    expect(find.text(GUEST_SAVED_TITLE), findsOneWidget);
    expect(find.text(GUEST_SAVED_SUBTITLE), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.text(AUTH_LOGIN_BUTTON), findsOneWidget);
    expect(find.text(AUTH_CREATE_ACCOUNT_BUTTON), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
  });

  testWidgets('GuestAuthPrompt in compact mode renders compact layout and action buttons', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GuestAuthPrompt(
            title: GUEST_REVIEW_TITLE,
            subtitle: GUEST_REVIEW_SUBTITLE,
            icon: Icons.rate_review_outlined,
            isCompact: true,
          ),
        ),
      ),
    );

    expect(find.text(GUEST_REVIEW_TITLE), findsOneWidget);
    expect(find.text(GUEST_REVIEW_SUBTITLE), findsOneWidget);
    expect(find.byIcon(Icons.rate_review_outlined), findsOneWidget);
    expect(find.text(AUTH_LOGIN_BUTTON), findsOneWidget);
    expect(find.text(AUTH_CREATE_ACCOUNT_BUTTON), findsOneWidget);
  });

  testWidgets('showGuestAuthSnackBar displays floating snackbar with Se connecter action', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showGuestAuthSnackBar(context, FAVORITES_GUEST_SNACKBAR_MESSAGE),
              child: const Text('Trigger'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Trigger'));
    await tester.pump();

    expect(find.text(FAVORITES_GUEST_SNACKBAR_MESSAGE), findsOneWidget);
    expect(find.text(ACTION_LOGIN), findsOneWidget);
  });
}
