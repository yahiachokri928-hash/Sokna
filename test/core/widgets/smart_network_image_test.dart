import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/widgets/smart_network_image.dart';

void main() {
  final samplePngBytes = Uint8List.fromList([
    137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82,
    0, 0, 0, 1, 0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137, 0,
    0, 0, 10, 73, 68, 65, 84, 120, 156, 99, 0, 1, 0, 0, 5, 0, 1,
    13, 10, 45, 180, 0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130
  ]);

  testWidgets('SmartNetworkImage renders fallback icon when imageUrl is empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SmartNetworkImage(imageUrl: ''),
        ),
      ),
    );

    expect(find.byIcon(Icons.home_work_rounded), findsOneWidget);
  });

  testWidgets('SmartNetworkImage renders Image.memory when imageUrl is a data URI', (tester) async {
    final dataUri = 'data:image/png;base64,${base64Encode(samplePngBytes)}';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SmartNetworkImage(imageUrl: dataUri),
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('SmartNetworkImage renders Image.network when imageUrl is a web URL', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SmartNetworkImage(imageUrl: 'https://images.unsplash.com/sample.jpg'),
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
  });
}
