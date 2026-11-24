import 'package:flutter/material.dart';

import '../strings/messages.dart';

class SoknaLogo extends StatelessWidget {
  final bool isCompact;
  final double? size;

  const SoknaLogo({
    super.key,
    this.isCompact = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    if (isCompact) {
      final double compactDimension = size ?? 34.0;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compactDimension,
            height: compactDimension,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(9.0),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.25),
                  blurRadius: 6.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.home_work_rounded,
              color: Colors.white,
              size: compactDimension * 0.55,
            ),
          ),
          const SizedBox(width: 10.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                APP_TITLE,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 5.0),
              Text(
                APP_ARABIC_NAME,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      );
    }

    final double emblemDimension = size ?? 72.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: emblemDimension,
          height: emblemDimension,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor,
                theme.colorScheme.primaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(emblemDimension * 0.28),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.3),
                blurRadius: 16.0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            Icons.home_work_rounded,
            color: Colors.white,
            size: emblemDimension * 0.52,
          ),
        ),
        const SizedBox(height: 14.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              APP_TITLE,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              APP_ARABIC_NAME,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Text(
          APP_SUBTITLE,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
