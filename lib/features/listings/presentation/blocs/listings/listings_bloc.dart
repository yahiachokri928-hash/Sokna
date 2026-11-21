import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sokna/core/strings/messages.dart';
import 'package:sokna/features/listings/domain/entities/listing_entity.dart';
import 'package:sokna/features/listings/domain/usecases/add_listing.dart';
import 'package:sokna/features/listings/domain/usecases/get_listings.dart';

part 'listings_event.dart';
part 'listings_state.dart';

class ListingsBloc extends Bloc<ListingsEvent, ListingsState> {
  final GetListingsUseCase getListingsUseCase;
  final AddListingUseCase addListingUseCase;

  ListingsBloc({
    required this.getListingsUseCase,
    required this.addListingUseCase,
  }) : super(ListingsInitial()) {
    on<GetListingsEvent>(_onGetListings);
    on<FilterListingsEvent>(_onFilterListings);
    on<AddListingEvent>(_onAddListing);
  }

  Future<void> _onGetListings(
    GetListingsEvent event,
    Emitter<ListingsState> emit,
  ) async {
    if (state is! ListingsLoaded || event.refresh) {
      emit(ListingsLoading());
    }

    final failureOrListings = await getListingsUseCase();

    failureOrListings.fold(
      (failure) => emit(ListingsError(message: failure.message)),
      (listings) {
        emit(ListingsLoaded(
          allListings: listings,
          filteredListings: listings,
          selectedCategory: CATEGORY_ALL,
          searchQuery: '',
        ));
      },
    );
  }

  void _onFilterListings(
    FilterListingsEvent event,
    Emitter<ListingsState> emit,
  ) {
    if (state is ListingsLoaded) {
      final current = state as ListingsLoaded;
      final filtered = _applyFilters(
        allListings: current.allListings,
        query: event.query,
        category: event.selectedCategory,
        maxPrice: event.maxPrice,
        minRooms: event.minRooms,
      );

      emit(current.copyWith(
        filteredListings: filtered,
        searchQuery: event.query,
        selectedCategory: event.selectedCategory,
        maxPrice: event.maxPrice,
        minRooms: event.minRooms,
      ));
    }
  }

  Future<void> _onAddListing(
    AddListingEvent event,
    Emitter<ListingsState> emit,
  ) async {
    final failureOrUnit = await addListingUseCase(event.listing);

    failureOrUnit.fold(
      (failure) => emit(ListingsError(message: failure.message)),
      (_) {
        if (state is ListingsLoaded) {
          final current = state as ListingsLoaded;
          final updatedAll = [event.listing, ...current.allListings];
          final updatedFiltered = _applyFilters(
            allListings: updatedAll,
            query: current.searchQuery,
            category: current.selectedCategory,
            maxPrice: current.maxPrice,
            minRooms: current.minRooms,
          );

          emit(current.copyWith(
            allListings: updatedAll,
            filteredListings: updatedFiltered,
          ));
        } else {
          emit(ListingsLoaded(
            allListings: [event.listing],
            filteredListings: [event.listing],
          ));
        }
      },
    );
  }

  List<ListingEntity> _applyFilters({
    required List<ListingEntity> allListings,
    required String query,
    required String category,
    int? maxPrice,
    int? minRooms,
  }) {
    final cleanQuery = query.toLowerCase().trim();

    return allListings.where((item) {
      // 1. Category filter
      if (category != CATEGORY_ALL &&
          item.propertyType.toLowerCase() != category.toLowerCase()) {
        return false;
      }

      // 2. Query filter (title, city, address)
      if (cleanQuery.isNotEmpty) {
        final matchesQuery = item.title.toLowerCase().contains(cleanQuery) ||
            item.city.toLowerCase().contains(cleanQuery) ||
            item.address.toLowerCase().contains(cleanQuery) ||
            item.propertyType.toLowerCase().contains(cleanQuery);
        if (!matchesQuery) return false;
      }

      // 3. Price filter
      if (maxPrice != null && item.price > maxPrice) {
        return false;
      }

      // 4. Rooms filter
      if (minRooms != null && item.rooms < minRooms) {
        return false;
      }

      return true;
    }).toList();
  }
}
