import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/utils/snack_bar_message.dart';
import '../../../auth/presentation/blocs/auth/auth_bloc.dart';
import '../../../favorites/presentation/blocs/saved_listings/saved_listings_bloc.dart';
import '../../domain/entities/listing_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../blocs/listings/listings_bloc.dart';
import '../blocs/reviews/reviews_bloc.dart';
import '../widgets/amenity_badge.dart';

class ListingDetailScreen extends StatefulWidget {
  final ListingEntity? listing;
  final String? listingId;

  const ListingDetailScreen({
    super.key,
    this.listing,
    this.listingId,
  });

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  double _selectedRating = 5.0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

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
                  currentListing.ownerPhone != null && currentListing.ownerPhone!.isNotEmpty
                      ? '${currentListing.ownerName} • ${currentListing.ownerPhone}'
                      : '${currentListing.ownerName} • ${currentListing.city}',
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

  void _submitReview(BuildContext context, ListingEntity currentListing) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthenticatedState) {
      SnackBarMessage.showErrorSnackBar(
        context: context,
        message: DETAIL_REVIEW_LOGIN_PROMPT,
      );
      context.push(AppRoutes.login);
      return;
    }

    final comment = _commentController.text.trim();
    if (comment.isEmpty) {
      SnackBarMessage.showErrorSnackBar(
        context: context,
        message: DETAIL_REVIEW_EMPTY_COMMENT,
      );
      return;
    }

    final user = authState.user;
    final userId = user.uid ?? '';
    final userName = (user.name != null && user.name!.isNotEmpty)
        ? user.name!
        : (user.email != null && user.email!.isNotEmpty
            ? user.email!.split('@').first
            : 'Locataire');

    final review = ReviewEntity(
      id: userId,
      listingId: currentListing.id,
      userId: userId,
      userName: userName,
      userAvatarUrl: user.profilURL,
      rating: _selectedRating,
      comment: comment,
      createdAt: DateTime.now(),
    );

    context.read<ReviewsBloc>().add(SubmitReviewEvent(review));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Resolve listing entity
    ListingEntity? item = widget.listing;
    if (item == null && widget.listingId != null) {
      final state = context.read<ListingsBloc>().state;
      if (state is ListingsLoaded) {
        for (final e in state.allListings) {
          if (e.id == widget.listingId) {
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

    return BlocProvider<ReviewsBloc>(
      create: (_) => sl<ReviewsBloc>()..add(LoadReviewsEvent(currentListing.id)),
      child: Builder(
        builder: (detailContext) {
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
                        onPressed: () => _showContactDialog(detailContext, currentListing),
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
            body: BlocConsumer<ReviewsBloc, ReviewsState>(
              listener: (context, reviewState) {
                if (reviewState is ReviewSubmittedSuccess) {
                  SnackBarMessage.showSuccessSnackBar(
                    context: context,
                    message: reviewState.message,
                  );
                  _commentController.clear();
                  setState(() {
                    _selectedRating = 5.0;
                  });
                  context.read<ReviewsBloc>().add(LoadReviewsEvent(currentListing.id));
                  context.read<ListingsBloc>().add(const GetListingsEvent(refresh: true));
                } else if (reviewState is ReviewsError) {
                  SnackBarMessage.showErrorSnackBar(
                    context: context,
                    message: reviewState.message,
                  );
                }
              },
              builder: (context, reviewState) {
                return CustomScrollView(
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
                      actions: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.85),
                            child: BlocBuilder<SavedListingsBloc, SavedListingsState>(
                              builder: (context, savedState) {
                                final isFav = savedState is SavedListingsLoaded &&
                                    savedState.isFavorite(currentListing.id);
                                return IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    color: isFav
                                        ? theme.colorScheme.error
                                        : theme.colorScheme.onSurface,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<SavedListingsBloc>()
                                        .add(ToggleSavedListingEvent(currentListing.id));
                                    SnackBarMessage.showSuccessSnackBar(
                                      context: context,
                                      message: isFav
                                          ? SNACKBAR_FAVORITE_REMOVED
                                          : SNACKBAR_FAVORITE_ADDED,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                      ],
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
                                      backgroundImage: (currentListing.ownerAvatarUrl != null &&
                                              currentListing.ownerAvatarUrl!.isNotEmpty)
                                          ? NetworkImage(currentListing.ownerAvatarUrl!)
                                          : null,
                                      child: (currentListing.ownerAvatarUrl == null ||
                                              currentListing.ownerAvatarUrl!.isEmpty)
                                          ? (currentListing.ownerName.isNotEmpty
                                              ? Text(
                                                  currentListing.ownerName.substring(0, 1).toUpperCase(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                    color: theme.colorScheme.primary,
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.person_rounded,
                                                  size: 28.0,
                                                  color: theme.colorScheme.primary,
                                                ))
                                          : null,
                                    ),
                                    const SizedBox(width: 14.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  currentListing.ownerName,
                                                  style: theme.textTheme.titleSmall?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
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
                                          if (currentListing.ownerPhone != null &&
                                              currentListing.ownerPhone!.isNotEmpty) ...[
                                            const SizedBox(height: 4.0),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.phone_rounded,
                                                  size: 14.0,
                                                  color: theme.colorScheme.primary,
                                                ),
                                                const SizedBox(width: 4.0),
                                                Text(
                                                  currentListing.ownerPhone!,
                                                  style: theme.textTheme.bodySmall?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: theme.colorScheme.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 28.0),

                            // Reviews Section (Phase C2)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DETAIL_REVIEWS_TITLE,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (reviewState is ReviewsLoaded && reviewState.reviews.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      '${reviewState.reviews.length} avis',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12.0),

                            // Reviews content list
                            if (reviewState is ReviewsLoading)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else if (reviewState is ReviewsLoaded && reviewState.reviews.isEmpty)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      color: theme.colorScheme.primary,
                                      size: 24.0,
                                    ),
                                    const SizedBox(width: 12.0),
                                    Expanded(
                                      child: Text(
                                        DETAIL_NO_REVIEWS,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (reviewState is ReviewsLoaded)
                              Column(
                                children: reviewState.reviews.map((rev) {
                                  return Card(
                                    elevation: 0,
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 16.0,
                                                backgroundColor: theme.colorScheme.primaryContainer,
                                                backgroundImage: (rev.userAvatarUrl != null &&
                                                        rev.userAvatarUrl!.isNotEmpty)
                                                    ? NetworkImage(rev.userAvatarUrl!)
                                                    : null,
                                                child: (rev.userAvatarUrl == null ||
                                                        rev.userAvatarUrl!.isEmpty)
                                                    ? Text(
                                                        rev.userName.isNotEmpty
                                                            ? rev.userName.substring(0, 1).toUpperCase()
                                                            : 'U',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.bold,
                                                          color: theme.colorScheme.primary,
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                              const SizedBox(width: 8.0),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      rev.userName,
                                                      style: theme.textTheme.bodyMedium?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${rev.createdAt.day.toString().padLeft(2, '0')}/${rev.createdAt.month.toString().padLeft(2, '0')}/${rev.createdAt.year}',
                                                      style: theme.textTheme.bodySmall?.copyWith(
                                                        color: theme.colorScheme.onSurfaceVariant,
                                                        fontSize: 11.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: List.generate(5, (starIdx) {
                                                  return Icon(
                                                    starIdx < rev.rating.round()
                                                        ? Icons.star_rounded
                                                        : Icons.star_border_rounded,
                                                    size: 16.0,
                                                    color: Colors.amber.shade700,
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            rev.comment,
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                            const SizedBox(height: 24.0),

                            // Add Review Form
                            Card(
                              elevation: 0,
                              color: theme.colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: BorderSide(
                                  color: theme.colorScheme.outlineVariant,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DETAIL_ADD_REVIEW_TITLE,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12.0),

                                    // Star selector
                                    Row(
                                      children: [
                                        Text(
                                          DETAIL_REVIEW_RATING_LABEL,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Row(
                                          children: List.generate(5, (index) {
                                            final starValue = (index + 1).toDouble();
                                            return InkWell(
                                              borderRadius: BorderRadius.circular(20.0),
                                              onTap: () {
                                                setState(() {
                                                  _selectedRating = starValue;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                child: Icon(
                                                  index < _selectedRating
                                                      ? Icons.star_rounded
                                                      : Icons.star_border_rounded,
                                                  color: Colors.amber.shade700,
                                                  size: 28.0,
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${_selectedRating.toStringAsFixed(0)} / 5',
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12.0),

                                    // Comment Input
                                    TextField(
                                      controller: _commentController,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        labelText: DETAIL_REVIEW_COMMENT_LABEL,
                                        hintText: DETAIL_REVIEW_COMMENT_HINT,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        contentPadding: const EdgeInsets.all(12.0),
                                      ),
                                    ),
                                    const SizedBox(height: 12.0),

                                    // Submit Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: reviewState is ReviewSubmitting
                                            ? null
                                            : () => _submitReview(detailContext, currentListing),
                                        icon: reviewState is ReviewSubmitting
                                            ? const SizedBox(
                                                width: 18.0,
                                                height: 18.0,
                                                child: CircularProgressIndicator(strokeWidth: 2.0),
                                              )
                                            : const Icon(Icons.send_rounded),
                                        label: const Text(DETAIL_REVIEW_SUBMIT_BUTTON),
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size.fromHeight(44.0),
                                        ),
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
