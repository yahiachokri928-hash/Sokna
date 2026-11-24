import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sokna/core/utils/image_encoding_helper.dart';

void main() {
  group('ImageEncodingHelper', () {
    test('isDataUri identifies data URIs accurately', () {
      expect(ImageEncodingHelper.isDataUri('data:image/jpeg;base64,/9j/4AAQSkZJRg=='), isTrue);
      expect(ImageEncodingHelper.isDataUri('data:image/png;base64,iVBORw0KGgo=='), isTrue);
      expect(ImageEncodingHelper.isDataUri('https://example.com/photo.jpg'), isFalse);
      expect(ImageEncodingHelper.isDataUri('assets/photo.jpg'), isFalse);
      expect(ImageEncodingHelper.isDataUri(''), isFalse);
      expect(ImageEncodingHelper.isDataUri(null), isFalse);
    });

    test('bytesToDataUri produces valid data URI header and base64', () {
      final sampleBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final uri = ImageEncodingHelper.bytesToDataUri(sampleBytes);

      expect(uri.startsWith('data:image/jpeg;base64,'), isTrue);
      expect(uri, 'data:image/jpeg;base64,${base64Encode(sampleBytes)}');
    });

    test('decodeDataUri successfully decodes base64 payload into bytes', () {
      final originalBytes = Uint8List.fromList([10, 20, 30, 40, 50, 60]);
      final uri = ImageEncodingHelper.bytesToDataUri(originalBytes);

      final decoded = ImageEncodingHelper.decodeDataUri(uri);
      expect(decoded, isNotNull);
      expect(decoded, originalBytes);
    });

    test('decodeDataUri returns null for invalid or empty inputs', () {
      expect(ImageEncodingHelper.decodeDataUri(null), isNull);
      expect(ImageEncodingHelper.decodeDataUri(''), isNull);
      expect(ImageEncodingHelper.decodeDataUri('https://example.com/test.jpg'), isNull);
    });

    test('xFileToDataUri encodes XFile within size limit', () async {
      final bytes = Uint8List.fromList([100, 101, 102]);
      final xFile = XFile.fromData(bytes, name: 'test.jpg');

      final result = await ImageEncodingHelper.xFileToDataUri(xFile);
      expect(result, isNotNull);
      expect(result!.startsWith('data:image/jpeg;base64,'), isTrue);
    });

    test('xFileToDataUri returns null if file exceeds maxSize', () async {
      final oversizedBytes = Uint8List(500);
      final xFile = XFile.fromData(oversizedBytes, name: 'large.jpg');

      final result = await ImageEncodingHelper.xFileToDataUri(xFile, maxSize: 250);
      expect(result, isNull);
    });
  });
}
