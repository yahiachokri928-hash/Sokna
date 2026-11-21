import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sokna/features/favorites/domain/usecases/get_saved_listing_ids.dart';
import 'package:sokna/features/favorites/domain/usecases/toggle_saved_listing.dart';

part 'saved_listings_event.dart';
part 'saved_listings_state.dart';

class SavedListingsBloc extends Bloc<SavedListingsEvent, SavedListingsState> {
  final GetSavedListingIdsUseCase getSavedListingIdsUseCase;
  final ToggleSavedListingUseCase toggleSavedListingUseCase;

  SavedListingsBloc({
    required this.getSavedListingIdsUseCase,
    required this.toggleSavedListingUseCase,
  }) : super(SavedListingsInitial()) {
    on<LoadSavedListingsEvent>(_onLoadSavedListings);
    on<ToggleSavedListingEvent>(_onToggleSavedListing);
  }

  Future<void> _onLoadSavedListings(
    LoadSavedListingsEvent event,
    Emitter<SavedListingsState> emit,
  ) async {
    emit(SavedListingsLoading());
    final failureOrIds = await getSavedListingIdsUseCase();

    failureOrIds.fold(
      (failure) => emit(SavedListingsError(message: failure.message)),
      (ids) => emit(SavedListingsLoaded(savedIds: ids)),
    );
  }

  Future<void> _onToggleSavedListing(
    ToggleSavedListingEvent event,
    Emitter<SavedListingsState> emit,
  ) async {
    final failureOrIds = await toggleSavedListingUseCase(event.listingId);

    failureOrIds.fold(
      (failure) => emit(SavedListingsError(message: failure.message)),
      (updatedIds) => emit(SavedListingsLoaded(savedIds: updatedIds)),
    );
  }
}
