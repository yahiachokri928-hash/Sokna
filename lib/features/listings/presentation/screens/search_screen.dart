import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../blocs/listings/listings_bloc.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/custom_empty_state.dart';
import '../widgets/listing_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  double _maxPrice = 5000.0;
  double _minRooms = 1.0;
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    final state = context.read<ListingsBloc>().state;
    final selectedCategory = state is ListingsLoaded ? state.selectedCategory : CATEGORY_ALL;

    context.read<ListingsBloc>().add(
          FilterListingsEvent(
            query: query,
            selectedCategory: selectedCategory,
            maxPrice: _maxPrice < 5000 ? _maxPrice.round() : null,
            minRooms: _minRooms > 1 ? _minRooms.round() : null,
          ),
        );
  }

  void _resetAllFilters() {
    setState(() {
      _searchController.clear();
      _maxPrice = 5000.0;
      _minRooms = 1.0;
    });

    context.read<ListingsBloc>().add(
          const FilterListingsEvent(
            query: '',
            selectedCategory: CATEGORY_ALL,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(SEARCH_TITLE),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_alt_off_rounded : Icons.filter_alt_rounded,
              color: _showFilters ? theme.colorScheme.primary : null,
            ),
            tooltip: SEARCH_FILTER_SECTION,
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: SEARCH_RESET_FILTERS,
            onPressed: _resetAllFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onQueryChanged,
              decoration: InputDecoration(
                hintText: SEARCH_INPUT_LABEL,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _onQueryChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Horizontal Category Chips
          BlocBuilder<ListingsBloc, ListingsState>(
            builder: (context, state) {
              final selectedCategory =
                  state is ListingsLoaded ? state.selectedCategory : CATEGORY_ALL;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CategoryFilterBar(
                  selectedCategory: selectedCategory,
                  onSelected: (cat) {
                    context.read<ListingsBloc>().add(
                          FilterListingsEvent(
                            query: _searchController.text,
                            selectedCategory: cat,
                            maxPrice: _maxPrice < 5000 ? _maxPrice.round() : null,
                            minRooms: _minRooms > 1 ? _minRooms.round() : null,
                          ),
                        );
                  },
                ),
              );
            },
          ),

          // Advanced Filters Expandable Card
          if (_showFilters)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        SEARCH_FILTER_PRICE,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_maxPrice.round()} TND',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _maxPrice,
                    min: 400.0,
                    max: 5000.0,
                    divisions: 23,
                    onChanged: (val) {
                      setState(() {
                        _maxPrice = val;
                      });
                      _onQueryChanged(_searchController.text);
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        SEARCH_FILTER_ROOMS,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$LISTING_ROOM_PREFIX${_minRooms.round()}',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _minRooms,
                    min: 1.0,
                    max: 6.0,
                    divisions: 5,
                    onChanged: (val) {
                      setState(() {
                        _minRooms = val;
                      });
                      _onQueryChanged(_searchController.text);
                    },
                  ),
                ],
              ),
            ),

          // Results Count Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<ListingsBloc, ListingsState>(
                  builder: (context, state) {
                    if (state is ListingsLoaded) {
                      return Text(
                        '${state.filteredListings.length} $SEARCH_RESULTS_SUFFIX',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          // Filtered Listings List
          Expanded(
            child: BlocBuilder<ListingsBloc, ListingsState>(
              builder: (context, state) {
                if (state is ListingsLoading) {
                  return const LoadingWidget();
                }

                if (state is ListingsError) {
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
                          Text(state.message, textAlign: TextAlign.center),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ListingsBloc>()
                                  .add(const GetListingsEvent(refresh: true));
                            },
                            child: const Text(ACTION_RETRY),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is ListingsLoaded) {
                  final listings = state.filteredListings;

                  if (listings.isEmpty) {
                    return CustomEmptyState(
                      onReset: _resetAllFilters,
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
                    itemCount: listings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                    itemBuilder: (context, index) {
                      final item = listings[index];
                      return ListingCard(
                        listing: item,
                        onTap: () {
                          context.push(
                            AppRoutes.listingDetail,
                            extra: item,
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
