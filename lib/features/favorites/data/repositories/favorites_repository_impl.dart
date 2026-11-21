import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/strings/failures.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<String>>> getSavedListingIds() async {
    try {
      final ids = await localDataSource.getSavedListingIds();
      return Right(ids);
    } on CacheException {
      return const Left(CacheFailure(CACHE_FAILURE_MESSAGE));
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, List<String>>> toggleSavedListing(String listingId) async {
    try {
      final updatedIds = await localDataSource.toggleSavedListing(listingId);
      return Right(updatedIds);
    } on CacheException {
      return const Left(CacheFailure(CACHE_FAILURE_MESSAGE));
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }
}
