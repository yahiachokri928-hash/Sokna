import 'package:flutter/material.dart';
import '../../../../core/strings/messages.dart';

class CustomEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onReset;

  const CustomEmptyState({
    super.key,
    this.title = SEARCH_NO_RESULTS,
    this.subtitle,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 56.0,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8.0),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (onReset != null) ...[
              const SizedBox(height: 20.0),
              OutlinedButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(SEARCH_RESET_FILTERS),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(200.0, 48.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
