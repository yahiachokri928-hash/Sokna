import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/utils/snack_bar_message.dart';
import '../../../auth/presentation/blocs/auth/auth_bloc.dart';
import '../../domain/entities/listing_entity.dart';
import 'amenity_badge.dart';

class ListingCard extends StatelessWidget {
  final ListingEntity listing;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const ListingCard({
    super.key,
    required this.listing,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  void _onFavoritePressed(BuildContext context) {
    AuthBloc? authBloc;
    try {
      authBloc = context.read<AuthBloc>();
    } catch (_) {
      authBloc = null;
    }

    if (authBloc != null && authBloc.state is! AuthenticatedState) {
      SnackBarMessage.showAuthRequiredSnackBar(
        context: context,
        message: FAVORITES_GUEST_SNACKBAR_MESSAGE,
        onAction: () => context.push(AppRoutes.login),
      );
      return;
    }

    onFavoriteToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack with Verified Badge & Favorite Button
            Stack(
              children: [
                SizedBox(
                  height: 180.0,
                  width: double.infinity,
                  child: Image.network(
                    listing.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.colorScheme.primaryContainer,
                        child: Center(
                          child: Icon(
                            Icons.home_work_rounded,
                            size: 48.0,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
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
                    },
                  ),
                ),
                // Verified Badge (top-left)
                Positioned(
                  top: 12.0,
                  left: 12.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 14.0,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          LISTING_CARD_VERIFIED,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Favorite Heart Toggle Button (top-right, 48x48 min touch target)
                Positioned(
                  top: 4.0,
                  right: 4.0,
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 48.0,
                        minHeight: 48.0,
                      ),
                      icon: Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(alpha: 0.85),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurface,
                          size: 20.0,
                        ),
                      ),
                      onPressed: () => _onFavoritePressed(context),
                    ),
                  ),
                ),
                // Price Tag (bottom-left overlay)
                Positioned(
                  bottom: 12.0,
                  left: 12.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '${listing.price} $DETAIL_PRICE_UNIT',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Information Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16.0,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          '${listing.city} • ${listing.address}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (listing.rating > 0) ...[
                        Icon(
                          Icons.star_rounded,
                          size: 16.0,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 2.0),
                        Text(
                          listing.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 6.0,
                    children: [
                      AmenityBadge(
                        icon: Icons.meeting_room_outlined,
                        label: '$LISTING_ROOM_PREFIX${listing.rooms}',
                      ),
                      AmenityBadge(
                        icon: Icons.square_foot_rounded,
                        label: '${listing.surface.toStringAsFixed(0)} $DETAIL_SURFACE_UNIT',
                      ),
                      AmenityBadge(
                        icon: listing.isFurnished
                            ? Icons.check_circle_outline_rounded
                            : Icons.cancel_outlined,
                        label: listing.isFurnished
                            ? DETAIL_FURNISHED_YES
                            : DETAIL_FURNISHED_NO,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
