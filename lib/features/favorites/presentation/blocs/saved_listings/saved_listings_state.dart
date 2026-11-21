part of 'saved_listings_bloc.dart';

abstract class SavedListingsState extends Equatable {
  const SavedListingsState();

  @override
  List<Object?> get props => [];
}

class SavedListingsInitial extends SavedListingsState {}

class SavedListingsLoading extends SavedListingsState {}

class SavedListingsLoaded extends SavedListingsState {
  final List<String> savedIds;

  const SavedListingsLoaded({required this.savedIds});

  bool isFavorite(String listingId) => savedIds.contains(listingId);

  int get count => savedIds.length;

  SavedListingsLoaded copyWith({List<String>? savedIds}) {
    return SavedListingsLoaded(
      savedIds: savedIds ?? this.savedIds,
    );
  }

  @override
  List<Object?> get props => [savedIds];
}

class SavedListingsError extends SavedListingsState {
  final String message;

  const SavedListingsError({required this.message});

  @override
  List<Object?> get props => [message];
}
