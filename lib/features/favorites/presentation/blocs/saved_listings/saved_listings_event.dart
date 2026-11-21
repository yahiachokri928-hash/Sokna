part of 'saved_listings_bloc.dart';

abstract class SavedListingsEvent extends Equatable {
  const SavedListingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavedListingsEvent extends SavedListingsEvent {
  const LoadSavedListingsEvent();
}

class ToggleSavedListingEvent extends SavedListingsEvent {
  final String listingId;

  const ToggleSavedListingEvent(this.listingId);

  @override
  List<Object?> get props => [listingId];
}
