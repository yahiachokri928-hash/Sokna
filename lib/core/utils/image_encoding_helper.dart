import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

/// Helper utility to process and encode images into compact Base64 JPEG Data URIs
/// suitable for storing inside Cloud Firestore documents without requiring Firebase Storage.
class ImageEncodingHelper {
  /// Maximum byte size per image (~180 KB) so up to 4 images stay well below Firestore 1 MB document limit.
  static const int maxByteSize = 180 * 1024; // 184,320 bytes

  /// Converts an [XFile] to a compact Base64 JPEG Data URI string.
  /// Returns null if the file exceeds [maxSize].
  static Future<String?> xFileToDataUri(
    XFile file, {
    int maxSize = maxByteSize,
  }) async {
    try {
      final Uint8List bytes = await file.readAsBytes();
      if (bytes.lengthInBytes > maxSize) {
        return null;
      }
      final String base64Payload = base64Encode(bytes);
      return 'data:image/jpeg;base64,$base64Payload';
    } catch (_) {
      return null;
    }
  }

  /// Converts raw [Uint8List] bytes to a Base64 JPEG Data URI string.
  static String bytesToDataUri(Uint8List bytes) {
    final String base64Payload = base64Encode(bytes);
    return 'data:image/jpeg;base64,$base64Payload';
  }

  /// Checks if a given image path/URL is a Base64 Data URI.
  static bool isDataUri(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('data:image');
  }

  /// Decodes a Base64 Data URI into raw [Uint8List] bytes.
  static Uint8List? decodeDataUri(String? dataUri) {
    if (dataUri == null || !isDataUri(dataUri)) return null;
    try {
      final int commaIndex = dataUri.indexOf(',');
      final String payload =
          commaIndex != -1 ? dataUri.substring(commaIndex + 1) : dataUri;
      final cleanPayload =
          payload.replaceAll('\n', '').replaceAll('\r', '').trim();
      return base64Decode(cleanPayload);
    } catch (_) {
      return null;
    }
  }

  /// Returns an [ImageProvider] supporting both Base64 Data URIs (via [MemoryImage])
  /// and standard network URLs (via [NetworkImage]). Returns null if [avatarUrl] is null or empty.
  static ImageProvider? getAvatarImageProvider(String? avatarUrl) {
    if (avatarUrl == null || avatarUrl.trim().isEmpty) return null;
    final trimmed = avatarUrl.trim();
    if (isDataUri(trimmed)) {
      final bytes = decodeDataUri(trimmed);
      if (bytes != null && bytes.isNotEmpty) {
        return MemoryImage(bytes);
      }
      return null;
    }
    return NetworkImage(trimmed);
  }
}
