import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/strings/messages.dart';
import 'package:sokna/features/listings/domain/entities/listing_entity.dart';
import 'package:sokna/features/listings/presentation/widgets/post_listing_form.dart';

void main() {
  Widget buildTestableWidget(ValueChanged<ListingEntity> onSubmitted) {
    return MaterialApp(
      home: Scaffold(
        body: PostListingForm(
          onListingSubmitted: onSubmitted,
        ),
      ),
    );
  }

  testWidgets('Submitting empty form triggers validation errors', (WidgetTester tester) async {
    bool submitted = false;

    await tester.pumpWidget(
      buildTestableWidget((_) {
        submitted = true;
      }),
    );

    // Find submit button and scroll to it if necessary
    final submitButtonFinder = find.text(POST_SUBMIT_BUTTON);
    expect(submitButtonFinder, findsOneWidget);

    await tester.ensureVisible(submitButtonFinder);
    await tester.pumpAndSettle();

    await tester.tap(submitButtonFinder);
    await tester.pumpAndSettle();

    // Verification: form should not be submitted and validation error should appear
    expect(submitted, isFalse);
    expect(find.text(VALIDATION_REQUIRED), findsWidgets);
  });

  testWidgets('Submitting title shorter than 5 chars triggers VALIDATION_TITLE_MIN_LENGTH', (WidgetTester tester) async {
    bool submitted = false;

    await tester.pumpWidget(
      buildTestableWidget((_) {
        submitted = true;
      }),
    );

    // Enter a 3-character title
    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.first, 'App');
    await tester.pumpAndSettle();

    final submitButtonFinder = find.text(POST_SUBMIT_BUTTON);
    await tester.ensureVisible(submitButtonFinder);
    await tester.pumpAndSettle();

    await tester.tap(submitButtonFinder);
    await tester.pumpAndSettle();

    expect(submitted, isFalse);
    expect(find.text(VALIDATION_TITLE_MIN_LENGTH), findsOneWidget);
  });

  testWidgets('Renders multi-photo section with gallery and camera buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestableWidget((_) {}),
    );

    expect(find.text(POST_PHOTOS_SECTION_TITLE), findsOneWidget);
    expect(find.text(POST_PHOTO_GALLERY_BTN), findsOneWidget);
    expect(find.text(POST_PHOTO_CAMERA_BTN), findsOneWidget);
    expect(find.text('0 / 4'), findsOneWidget);
  });
}
