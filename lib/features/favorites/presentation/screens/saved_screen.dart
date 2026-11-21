import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/utils/snack_bar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../listings/presentation/blocs/listings/listings_bloc.dart';
import '../../../listings/presentation/widgets/custom_empty_state.dart';
import '../../../listings/presentation/widgets/listing_card.dart';
import '../blocs/saved_listings/saved_listings_bloc.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(SAVED_APP_BAR_TITLE),
      ),
      body: BlocBuilder<SavedListingsBloc, SavedListingsState>(
        builder: (context, savedState) {
          if (savedState is SavedListingsLoading || savedState is SavedListingsInitial) {
            return const LoadingWidget();
          }

          if (savedState is SavedListingsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48.0,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 12.0),
                    Text(savedState.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<SavedListingsBloc>()
                            .add(const LoadSavedListingsEvent());
                      },
                      child: const Text(ACTION_RETRY),
                    ),
                  ],
                ),
              ),
            );
          }

          final savedIds = (savedState as SavedListingsLoaded).savedIds;

          return BlocBuilder<ListingsBloc, ListingsState>(
            builder: (context, listingsState) {
              if (listingsState is ListingsLoading || listingsState is ListingsInitial) {
                return const LoadingWidget();
              }

              final allListings = listingsState is ListingsLoaded
                  ? listingsState.allListings
                  : const [];

              final savedListings = allListings
                  .where((item) => savedIds.contains(item.id))
                  .toList();

              if (savedListings.isEmpty) {
                return CustomEmptyState(
                  title: SAVED_EMPTY_TITLE,
                  subtitle: SAVED_EMPTY_SUBTITLE,
                  onReset: () => context.go(AppRoutes.home),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
                itemCount: savedListings.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  final listing = savedListings[index];
                  return ListingCard(
                    listing: listing,
                    isFavorite: true,
                    onTap: () {
                      context.push(
                        AppRoutes.listingDetail,
                        extra: listing,
                      );
                    },
                    onFavoriteToggle: () {
                      context
                          .read<SavedListingsBloc>()
                          .add(ToggleSavedListingEvent(listing.id));
                      SnackBarMessage.showSuccessSnackBar(
                        context: context,
                        message: SNACKBAR_FAVORITE_REMOVED,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
