import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/strings/messages.dart';
import '../../../../core/utils/snack_bar_message.dart';
import '../../../../core/widgets/guest_auth_prompt.dart';
import '../../../auth/presentation/blocs/auth/auth_bloc.dart';
import '../../domain/entities/listing_entity.dart';
import '../blocs/listings/listings_bloc.dart';
import '../widgets/post_listing_form.dart';

class PostListingScreen extends StatelessWidget {
  const PostListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthenticatedState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(POST_APP_BAR_TITLE),
            ),
            body: const SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.0),
                  child: GuestAuthPrompt(
                    icon: Icons.add_home_work_rounded,
                    title: GUEST_POST_TITLE,
                    subtitle: GUEST_POST_SUBTITLE,
                  ),
                ),
              ),
            ),
          );
        }

        final authUser = state.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text(POST_APP_BAR_TITLE),
          ),
          body: SafeArea(
            child: PostListingForm(
              onListingSubmitted: (newListing) {
                final listingWithOwner = ListingEntity(
                  id: newListing.id,
                  title: newListing.title,
                  city: newListing.city,
                  address: newListing.address,
                  propertyType: newListing.propertyType,
                  price: newListing.price,
                  rooms: newListing.rooms,
                  surface: newListing.surface,
                  isFurnished: newListing.isFurnished,
                  hasParking: newListing.hasParking,
                  imagePath: newListing.imagePath,
                  imageUrls: newListing.imageUrls,
                  rating: newListing.rating,
                  reviewCount: newListing.reviewCount,
                  ownerName: (authUser.name != null && authUser.name!.isNotEmpty)
                      ? authUser.name!
                      : newListing.ownerName,
                  availableFrom: newListing.availableFrom,
                  description: newListing.description,
                  ownerId: authUser.uid,
                  ownerPhone: authUser.phone,
                  ownerAvatarUrl: authUser.profilURL,
                );

                context.read<ListingsBloc>().add(AddListingEvent(listingWithOwner));

                SnackBarMessage.showSuccessSnackBar(
                  context: context,
                  message: POST_SUCCESS_MESSAGE,
                );

                context.pop(listingWithOwner);
              },
            ),
          ),
        );
      },
    );
  }
}
