import 'package:flutter/material.dart';
import '../../../../core/strings/messages.dart';

class ListingDetailScreen extends StatelessWidget {
  final String? listingId;

  const ListingDetailScreen({
    super.key,
    this.listingId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(DETAIL_APP_BAR_TITLE),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.apartment_rounded,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                DETAIL_APP_BAR_TITLE,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (listingId != null) ...[
                const SizedBox(height: 8),
                Text(
                  'ID: $listingId',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
