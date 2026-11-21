import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/utils/snack_bar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/blocs/auth/auth_bloc.dart';
import '../../domain/entities/listing_entity.dart';
import '../blocs/listings/listings_bloc.dart';
import '../widgets/post_listing_form.dart';

class PostListingScreen extends StatelessWidget {
  const PostListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is! AuthenticatedState) {
          SnackBarMessage.showErrorSnackBar(
            context: context,
            message: POST_LOGIN_REQUIRED_MESSAGE,
          );
          context.pushReplacement(AppRoutes.login);
        }
      },
      builder: (context, state) {
        if (state is! AuthenticatedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SnackBarMessage.showErrorSnackBar(
              context: context,
              message: POST_LOGIN_REQUIRED_MESSAGE,
            );
            context.pushReplacement(AppRoutes.login);
          });
          return const Scaffold(
            body: Center(child: LoadingWidget()),
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
                  rating: newListing.rating,
                  reviewCount: newListing.reviewCount,
                  ownerName: (authUser.name != null && authUser.name!.isNotEmpty)
                      ? authUser.name!
                      : newListing.ownerName,
                  availableFrom: newListing.availableFrom,
                  description: newListing.description,
                  ownerId: authUser.uid,
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
