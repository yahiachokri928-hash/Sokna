import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sokna/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:sokna/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:sokna/features/favorites/domain/usecases/get_saved_listing_ids.dart';
import 'package:sokna/features/favorites/domain/usecases/toggle_saved_listing.dart';
import 'package:sokna/features/favorites/presentation/blocs/saved_listings/saved_listings_bloc.dart';

void main() {
  late SharedPreferences sharedPreferences;
  late FavoritesLocalDataSource localDataSource;
  late FavoritesRepositoryImpl repository;
  late GetSavedListingIdsUseCase getSavedListingIdsUseCase;
  late ToggleSavedListingUseCase toggleSavedListingUseCase;
  late SavedListingsBloc bloc;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    localDataSource = FavoritesLocalDataSourceImpl(sharedPreferences: sharedPreferences);
    repository = FavoritesRepositoryImpl(localDataSource: localDataSource);
    getSavedListingIdsUseCase = GetSavedListingIdsUseCase(repository);
    toggleSavedListingUseCase = ToggleSavedListingUseCase(repository);
    bloc = SavedListingsBloc(
      getSavedListingIdsUseCase: getSavedListingIdsUseCase,
      toggleSavedListingUseCase: toggleSavedListingUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be SavedListingsInitial', () {
    expect(bloc.state, isA<SavedListingsInitial>());
  });

  test('LoadSavedListingsEvent should emit [SavedListingsLoading, SavedListingsLoaded] with empty list', () async {
    final expected = [
      isA<SavedListingsLoading>(),
      isA<SavedListingsLoaded>().having((s) => s.savedIds, 'savedIds', isEmpty),
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    bloc.add(const LoadSavedListingsEvent());
  });

  test('ToggleSavedListingEvent should add ID, persist to SharedPreferences, and avoid duplicates (RG-03, EF7)', () async {
    bloc.add(const ToggleSavedListingEvent('sokna_001'));

    await expectLater(
      bloc.stream,
      emits(
        isA<SavedListingsLoaded>().having(
          (s) => s.savedIds,
          'savedIds',
          ['sokna_001'],
        ),
      ),
    );

    // Verify persistence in SharedPreferences (EF7)
    final stored = sharedPreferences.getStringList(FavoritesLocalDataSourceImpl.savedListingsKey);
    expect(stored, ['sokna_001']);

    // Toggle same ID again: should remove it (RG-04)
    bloc.add(const ToggleSavedListingEvent('sokna_001'));

    await expectLater(
      bloc.stream,
      emits(
        isA<SavedListingsLoaded>().having(
          (s) => s.savedIds,
          'savedIds',
          isEmpty,
        ),
      ),
    );

    final storedAfterRemove = sharedPreferences.getStringList(FavoritesLocalDataSourceImpl.savedListingsKey);
    expect(storedAfterRemove, isEmpty);
  });
}
