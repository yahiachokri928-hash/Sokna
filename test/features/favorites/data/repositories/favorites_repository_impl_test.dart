import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/network/network_info.dart';
import 'package:sokna/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:sokna/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:sokna/features/favorites/data/repositories/favorites_repository_impl.dart';

class MockLocalDataSource implements FavoritesLocalDataSource {
  List<String> storage = ['sokna_001'];

  @override
  Future<List<String>> getSavedListingIds() async => List.from(storage);

  @override
  Future<List<String>> toggleSavedListing(String listingId) async {
    if (storage.contains(listingId)) {
      storage.remove(listingId);
    } else {
      storage.add(listingId);
    }
    return List.from(storage);
  }

  @override
  Future<void> saveSavedListingIds(List<String> ids) async {
    storage = List.from(ids);
  }
}

class MockRemoteDataSource implements FavoritesRemoteDataSource {
  List<String> cloudStorage = ['sokna_002', 'sokna_003'];

  @override
  Future<List<String>> getSavedListingIds(String uid) async =>
      List.from(cloudStorage);

  @override
  Future<List<String>> toggleSavedListing(String uid, String listingId) async {
    if (cloudStorage.contains(listingId)) {
      cloudStorage.remove(listingId);
    } else {
      cloudStorage.add(listingId);
    }
    return List.from(cloudStorage);
  }
}

class MockNetworkInfo implements NetworkInfo {
  bool connected = true;

  @override
  Future<bool> get isConnected async => connected;
}

void main() {
  late MockLocalDataSource mockLocal;
  late MockRemoteDataSource mockRemote;
  late MockNetworkInfo mockNetwork;
  late FavoritesRepositoryImpl repository;

  setUp(() {
    mockLocal = MockLocalDataSource();
    mockRemote = MockRemoteDataSource();
    mockNetwork = MockNetworkInfo();
  });

  test('when unauthenticated, getSavedListingIds falls back to localDataSource (EF7)', () async {
    repository = FavoritesRepositoryImpl(
      localDataSource: mockLocal,
      remoteDataSource: mockRemote,
      networkInfo: mockNetwork,
      authService: null,
    );

    final result = await repository.getSavedListingIds();

    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => []), ['sokna_001']);
  });

  test('when network is offline, toggleSavedListing falls back to localDataSource (EF7)', () async {
    mockNetwork.connected = false;
    repository = FavoritesRepositoryImpl(
      localDataSource: mockLocal,
      remoteDataSource: mockRemote,
      networkInfo: mockNetwork,
      authService: null,
    );

    final result = await repository.toggleSavedListing('sokna_005');

    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => []), ['sokna_001', 'sokna_005']);
    expect(mockLocal.storage, contains('sokna_005'));
  });
}
