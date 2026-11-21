import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../entities/listing_entity.dart';

abstract class ListingRepository {
  Future<Either<Failure, List<ListingEntity>>> getListings();
  Future<Either<Failure, List<ListingEntity>>> searchListings(String query);
  Future<Either<Failure, Unit>> addListing(ListingEntity listing);
  Future<Either<Failure, Unit>> deleteListing(String listingId);
}
