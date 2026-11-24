import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../utils/image_encoding_helper.dart';

/// Unified image widget that seamlessly renders either a Base64 Data URI
/// (via [Image.memory]) or a network URL (via [Image.network]), with graceful
/// loading progress and Material 3 placeholder fallback on error.
class SmartNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final WidgetBuilder? placeholderBuilder;
  final WidgetBuilder? errorBuilder;

  const SmartNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholderBuilder,
    this.errorBuilder,
  });

  Widget _buildFallback(BuildContext context) {
    if (errorBuilder != null) {
      return errorBuilder!(context);
    }
    final theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      color: theme.colorScheme.primaryContainer,
      child: Center(
        child: Icon(
          Icons.home_work_rounded,
          size: 48.0,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildLoading(
      BuildContext context, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return const SizedBox.shrink();
    if (placeholderBuilder != null) {
      return placeholderBuilder!(context);
    }
    final theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: theme.colorScheme.primary,
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trimmedUrl = imageUrl.trim();

    if (trimmedUrl.isEmpty) {
      return _buildFallback(context);
    }

    if (ImageEncodingHelper.isDataUri(trimmedUrl)) {
      final Uint8List? bytes = ImageEncodingHelper.decodeDataUri(trimmedUrl);
      if (bytes == null || bytes.isEmpty) {
        return _buildFallback(context);
      }
      return Image.memory(
        bytes,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => _buildFallback(context),
      );
    }

    return Image.network(
      trimmedUrl,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoading(context, loadingProgress);
      },
      errorBuilder: (context, error, stackTrace) => _buildFallback(context),
    );
  }
}
