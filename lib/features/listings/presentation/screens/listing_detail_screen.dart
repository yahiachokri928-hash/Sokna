import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/strings/messages.dart';
import '../../domain/entities/listing_entity.dart';
import '../blocs/listings/listings_bloc.dart';
import '../widgets/amenity_badge.dart';

class ListingDetailScreen extends StatelessWidget {
  final ListingEntity? listing;
  final String? listingId;

  const ListingDetailScreen({
    super.key,
    this.listing,
    this.listingId,
  });

  void _showContactDialog(BuildContext context, ListingEntity currentListing) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  DETAIL_DIALOG_CONTACT_TITLE,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '${currentListing.ownerName} • ${currentListing.city}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Appel vers le bailleur ${currentListing.ownerName}...'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.phone_rounded),
                        label: const Text(DETAIL_DIALOG_CALL),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Message envoyé au bailleur ${currentListing.ownerName} !'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.sms_rounded),
                        label: const Text(DETAIL_DIALOG_SMS),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Resolve listing entity
    ListingEntity? item = listing;
    if (item == null && listingId != null) {
      final state = context.read<ListingsBloc>().state;
      if (state is ListingsLoaded) {
        for (final e in state.allListings) {
          if (e.id == listingId) {
            item = e;
            break;
          }
        }
      }
    }

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(DETAIL_APP_BAR_TITLE)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 56.0,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12.0),
              const Text(SEARCH_NO_RESULTS),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text(ACTION_CLOSE),
              ),
            ],
          ),
        ),
      );
    }

    final currentListing = item;
    final int deposit = currentListing.price * 2;
    final int initialTotal = currentListing.price * 3;

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10.0,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentListing.price} TND',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DETAIL_PRICE_UNIT,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showContactDialog(context, currentListing),
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                  label: const Text(DETAIL_CONTACT_BUTTON),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 280.0,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.85),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: theme.colorScheme.onSurface,
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    currentListing.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.colorScheme.primaryContainer,
                        child: Center(
                          child: Icon(
                            Icons.home_work_rounded,
                            size: 64.0,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            currentListing.propertyType,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (currentListing.rating > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade700,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 16.0, color: Colors.white),
                                const SizedBox(width: 4.0),
                                Text(
                                  '${currentListing.rating.toStringAsFixed(1)} (${currentListing.reviewCount})',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Location
                  Text(
                    currentListing.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 18.0,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          '${currentListing.address}, ${currentListing.city}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  // Financial breakdown card (Loyer + Caution 2 mois + Total initial)
                  Card(
                    elevation: 0,
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DETAIL_CHARACTERISTICS,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(POST_FIELD_PRICE),
                              Text(
                                '${currentListing.price} TND',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(DETAIL_DEPOSIT_TITLE),
                              Text(
                                '$deposit TND',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DETAIL_TOTAL_INITIAL,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Text(
                                '$initialTotal TND',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  // Amenities Grid
                  Text(
                    DETAIL_CHARACTERISTICS,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      AmenityBadge(
                        icon: Icons.meeting_room_rounded,
                        label: '$LISTING_ROOM_PREFIX${currentListing.rooms} ($DETAIL_ROOMS_COUNT)',
                      ),
                      AmenityBadge(
                        icon: Icons.square_foot_rounded,
                        label: '${currentListing.surface.toStringAsFixed(0)} $DETAIL_SURFACE_UNIT',
                      ),
                      AmenityBadge(
                        icon: currentListing.isFurnished
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        label: currentListing.isFurnished
                            ? DETAIL_FURNISHED_YES
                            : DETAIL_FURNISHED_NO,
                      ),
                      AmenityBadge(
                        icon: currentListing.hasParking
                            ? Icons.local_parking_rounded
                            : Icons.not_interested_rounded,
                        label: currentListing.hasParking
                            ? DETAIL_PARKING_YES
                            : DETAIL_PARKING_NO,
                      ),
                      AmenityBadge(
                        icon: Icons.event_available_rounded,
                        label: '$DETAIL_AVAILABLE_DATE ${currentListing.availableFrom}',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24.0),

                  // Description
                  Text(
                    DETAIL_DESCRIPTION_SECTION,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    currentListing.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // Verified Landlord Card
                  Card(
                    elevation: 0,
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26.0,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Icon(
                              Icons.person_rounded,
                              size: 28.0,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 14.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      currentListing.ownerName,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    Icon(
                                      Icons.verified_rounded,
                                      size: 16.0,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  DETAIL_VERIFIED_LANDLORD,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
