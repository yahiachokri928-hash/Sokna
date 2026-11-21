import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/failures/auth_failures.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/strings/failures.dart';
import '../../domain/entities/listing_entity.dart';
import '../../domain/repositories/listing_repository.dart';
import '../datasources/listing_data_source.dart';
import '../models/listing_model.dart';

class ListingRepositoryImpl implements ListingRepository {
  final ListingDataSource dataSource;
  final NetworkInfo networkInfo;

  ListingRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ListingEntity>>> getListings() async {
    try {
      final remoteListings = await dataSource.getListings();
      return Right(remoteListings);
    } on ServerException {
      return const Left(ServerFailure(SERVER_FAILURE_MESSAGE));
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, List<ListingEntity>>> searchListings(String query) async {
    try {
      final results = await dataSource.searchListings(query);
      return Right(results);
    } on ServerException {
      return const Left(ServerFailure(SERVER_FAILURE_MESSAGE));
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, Unit>> addListing(ListingEntity listing) async {
    try {
      final model = ListingModel.fromEntity(listing);
      await dataSource.addListing(model);
      return const Right(unit);
    } on AuthException {
      return const Left(AuthUnknownFailure(AUTH_REQUIRED_FAILURE_MESSAGE));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? SERVER_FAILURE_MESSAGE));
    } on ServerException {
      return const Left(ServerFailure(SERVER_FAILURE_MESSAGE));
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteListing(String listingId) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure(OFFLINE_FAILURE_MESSAGE));
    }

    try {
      await dataSource.deleteListing(listingId);
      return const Right(unit);
    } on AuthException {
      return const Left(AuthUnknownFailure(AUTH_REQUIRED_FAILURE_MESSAGE));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? SERVER_FAILURE_MESSAGE));
    } on ServerException {
      return const Left(ServerFailure(SERVER_FAILURE_MESSAGE));
    } catch (_) {
      return const Left(UnexpectedFailure(UNEXPECTED_FAILURE_MESSAGE));
    }
  }
}
