part of 'listings_bloc.dart';

abstract class ListingsState extends Equatable {
  const ListingsState();

  @override
  List<Object?> get props => [];
}

class ListingsInitial extends ListingsState {}

class ListingsLoading extends ListingsState {}

class ListingsLoaded extends ListingsState {
  final List<ListingEntity> allListings;
  final List<ListingEntity> filteredListings;
  final String selectedCategory;
  final String searchQuery;
  final int? maxPrice;
  final int? minRooms;

  const ListingsLoaded({
    required this.allListings,
    required this.filteredListings,
    this.selectedCategory = CATEGORY_ALL,
    this.searchQuery = '',
    this.maxPrice,
    this.minRooms,
  });

  ListingsLoaded copyWith({
    List<ListingEntity>? allListings,
    List<ListingEntity>? filteredListings,
    String? selectedCategory,
    String? searchQuery,
    int? maxPrice,
    int? minRooms,
  }) {
    return ListingsLoaded(
      allListings: allListings ?? this.allListings,
      filteredListings: filteredListings ?? this.filteredListings,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      maxPrice: maxPrice ?? this.maxPrice,
      minRooms: minRooms ?? this.minRooms,
    );
  }

  @override
  List<Object?> get props => [
        allListings,
        filteredListings,
        selectedCategory,
        searchQuery,
        maxPrice,
        minRooms,
      ];
}

class ListingsError extends ListingsState {
  final String message;

  const ListingsError({required this.message});

  @override
  List<Object?> get props => [message];
}
