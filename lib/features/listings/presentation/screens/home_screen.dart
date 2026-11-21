import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/utils/snack_bar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../favorites/presentation/blocs/saved_listings/saved_listings_bloc.dart';
import '../blocs/listings/listings_bloc.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/custom_empty_state.dart';
import '../widgets/listing_card.dart';
import '../widgets/toolbar_action_theme_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(APP_TITLE),
        actions: const [
          ToolbarActionThemeWidget(),
          SizedBox(width: 8.0),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await context.push(AppRoutes.postListing);
          if (result != null && context.mounted) {
            context.read<ListingsBloc>().add(const GetListingsEvent(refresh: true));
          }
        },
        icon: const Icon(Icons.add_home_rounded),
        label: const Text(NAV_POST),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ListingsBloc>().add(const GetListingsEvent(refresh: true));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Greeting Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      HOME_USER_GREETING,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      HOME_GREETING_TITLE,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      HOME_GREETING_SUBTITLE,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Trigger Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: InkWell(
                  onTap: () => context.go(AppRoutes.search),
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            HOME_SEARCH_PLACEHOLDER,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.tune_rounded,
                          size: 20.0,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8.0),

              // Categories Header & Filter Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  HOME_SECTION_CATEGORIES,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              BlocBuilder<ListingsBloc, ListingsState>(
                builder: (context, state) {
                  final selectedCategory = state is ListingsLoaded
                      ? state.selectedCategory
                      : CATEGORY_ALL;

                  return CategoryFilterBar(
                    selectedCategory: selectedCategory,
                    onSelected: (category) {
                      context.read<ListingsBloc>().add(
                            FilterListingsEvent(
                              query: state is ListingsLoaded ? state.searchQuery : '',
                              selectedCategory: category,
                              maxPrice: state is ListingsLoaded ? state.maxPrice : null,
                              minRooms: state is ListingsLoaded ? state.minRooms : null,
                            ),
                          );
                    },
                  );
                },
              ),

              const SizedBox(height: 16.0),

              // Recommended Listings Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      HOME_SECTION_RECOMMENDED,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    BlocBuilder<ListingsBloc, ListingsState>(
                      builder: (context, state) {
                        if (state is ListingsLoaded) {
                          return Text(
                            '${state.filteredListings.length} $SEARCH_RESULTS_SUFFIX',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),

              // Listings List or States
              BlocBuilder<ListingsBloc, ListingsState>(
                builder: (context, state) {
                  if (state is ListingsLoading || state is ListingsInitial) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: LoadingWidget(),
                    );
                  }

                  if (state is ListingsError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 48.0,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton.icon(
                              onPressed: () {
                                context
                                    .read<ListingsBloc>()
                                    .add(const GetListingsEvent(refresh: true));
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text(ACTION_RETRY),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is ListingsLoaded) {
                    final listings = state.filteredListings;

                    if (listings.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: CustomEmptyState(
                          onReset: () {
                            context.read<ListingsBloc>().add(
                                  const FilterListingsEvent(
                                    query: '',
                                    selectedCategory: CATEGORY_ALL,
                                  ),
                                );
                          },
                        ),
                      );
                    }

                    return BlocBuilder<SavedListingsBloc, SavedListingsState>(
                      builder: (context, savedState) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 80.0),
                          itemCount: listings.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                          itemBuilder: (context, index) {
                            final listing = listings[index];
                            final isFav = savedState is SavedListingsLoaded &&
                                savedState.isFavorite(listing.id);

                            return ListingCard(
                              listing: listing,
                              isFavorite: isFav,
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
                                  message: isFav
                                      ? SNACKBAR_FAVORITE_REMOVED
                                      : SNACKBAR_FAVORITE_ADDED,
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
