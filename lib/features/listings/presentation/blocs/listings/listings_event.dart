part of 'listings_bloc.dart';

abstract class ListingsEvent extends Equatable {
  const ListingsEvent();

  @override
  List<Object?> get props => [];
}

class GetListingsEvent extends ListingsEvent {
  final bool refresh;

  const GetListingsEvent({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class FilterListingsEvent extends ListingsEvent {
  final String query;
  final String selectedCategory;
  final int? maxPrice;
  final int? minRooms;

  const FilterListingsEvent({
    this.query = '',
    this.selectedCategory = CATEGORY_ALL,
    this.maxPrice,
    this.minRooms,
  });

  @override
  List<Object?> get props => [query, selectedCategory, maxPrice, minRooms];
}

class AddListingEvent extends ListingsEvent {
  final ListingEntity listing;

  const AddListingEvent(this.listing);

  @override
  List<Object?> get props => [listing];
}
