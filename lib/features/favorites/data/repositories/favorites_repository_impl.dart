import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/failures/auth_failures.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/firebase/auth_service.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/strings/failures.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';
import '../datasources/favorites_remote_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;
  final FavoritesRemoteDataSource? remoteDataSource;
  final AuthService? authService;
  final NetworkInfo? networkInfo;

  FavoritesRepositoryImpl({
    required this.localDataSource,
    this.remoteDataSource,
    this.authService,
    this.networkInfo,
  });

  @override
  Future<Either<Failure, List<String>>> getSavedListingIds() async {
    try {
      final user = authService?.currentUser;
      // Phase G1: When unauthenticated (guest), always return empty list
      if (user == null) {
        return const Right([]);
      }

      final isConnected =
          networkInfo != null ? await networkInfo!.isConnected : false;

      if (isConnected && remoteDataSource != null) {
        try {
          final cloudIds = await remoteDataSource!.getSavedListingIds(user.uid);
          // Mirror to local cache so offline cache stays up to date (ENF3)
          await localDataSource.saveSavedListingIds(cloudIds);
          return Right(cloudIds);
        } catch (_) {
          // Fallback to local cache if cloud fetch throws
          final localIds = await localDataSource.getSavedListingIds();
          return Right(localIds);
        }
      }

      // Authenticated user offline fallback (ENF3)
      final localIds = await localDataSource.getSavedListingIds();
      return Right(localIds);
    } on CacheException {
      return const Left(CacheFailure(CACHE_FAILURE_MESSAGE));
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, List<String>>> toggleSavedListing(
    String listingId,
  ) async {
    try {
      final user = authService?.currentUser;
      // Phase G1: When unauthenticated (guest), enforce cloud-only user data
      if (user == null) {
        return const Left(AuthFailure(LOGIN_REQUIRED_FAVORITES_MESSAGE));
      }

      final isConnected =
          networkInfo != null ? await networkInfo!.isConnected : false;

      if (isConnected && remoteDataSource != null) {
        try {
          final updatedCloudIds =
              await remoteDataSource!.toggleSavedListing(user.uid, listingId);
          // Mirror to local cache (ENF3)
          await localDataSource.saveSavedListingIds(updatedCloudIds);
          return Right(updatedCloudIds);
        } catch (_) {
          // Fallback to local toggle if cloud update throws
          final updatedLocal = await localDataSource.toggleSavedListing(listingId);
          return Right(updatedLocal);
        }
      }

      // Authenticated user offline toggle (ENF3)
      final updatedLocal = await localDataSource.toggleSavedListing(listingId);
      return Right(updatedLocal);
    } on CacheException {
      return const Left(CacheFailure(CACHE_FAILURE_MESSAGE));
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }
}
