import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/firebase/auth_service.dart';
import 'package:sokna/core/network/network_info.dart';
import 'package:sokna/core/strings/failures.dart';
import 'package:sokna/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:sokna/features/favorites/data/datasources/favorites_remote_data_source.dart';
import 'package:sokna/features/favorites/data/repositories/favorites_repository_impl.dart';

class FakeUser implements User {
  @override
  final String uid;
  FakeUser(this.uid);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAuthService extends AuthService {
  final User? mockUser;
  MockAuthService([this.mockUser]);

  @override
  User? get currentUser => mockUser;
}

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

  test('when unauthenticated, getSavedListingIds returns empty list (Phase G1 cloud-only)', () async {
    repository = FavoritesRepositoryImpl(
      localDataSource: mockLocal,
      remoteDataSource: mockRemote,
      networkInfo: mockNetwork,
      authService: null,
    );

    final result = await repository.getSavedListingIds();

    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => ['unexpected']), isEmpty);
  });

  test('when unauthenticated, toggleSavedListing returns Left(AuthFailure) (Phase G1 cloud-only)', () async {
    repository = FavoritesRepositoryImpl(
      localDataSource: mockLocal,
      remoteDataSource: mockRemote,
      networkInfo: mockNetwork,
      authService: null,
    );

    final result = await repository.toggleSavedListing('sokna_005');

    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) => expect(failure.message, LOGIN_REQUIRED_FAVORITES_MESSAGE),
      (_) => fail('Should return AuthFailure'),
    );
  });

  test('when authenticated and online, toggleSavedListing updates cloud and mirrors to local', () async {
    final fakeUser = FakeUser('user_123');
    final mockAuth = MockAuthService(fakeUser);
    repository = FavoritesRepositoryImpl(
      localDataSource: mockLocal,
      remoteDataSource: mockRemote,
      networkInfo: mockNetwork,
      authService: mockAuth,
    );

    final result = await repository.toggleSavedListing('sokna_005');

    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => []), contains('sokna_005'));
    expect(mockLocal.storage, contains('sokna_005'));
  });

  test('when authenticated and offline, toggleSavedListing falls back to localDataSource (EF7, ENF3)', () async {
    mockNetwork.connected = false;
    final fakeUser = FakeUser('user_123');
    final mockAuth = MockAuthService(fakeUser);
    repository = FavoritesRepositoryImpl(
      localDataSource: mockLocal,
      remoteDataSource: mockRemote,
      networkInfo: mockNetwork,
      authService: mockAuth,
    );

    final result = await repository.toggleSavedListing('sokna_005');

    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => []), contains('sokna_005'));
    expect(mockLocal.storage, contains('sokna_005'));
  });
}
