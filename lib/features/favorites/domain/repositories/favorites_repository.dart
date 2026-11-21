import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<String>>> getSavedListingIds();
  Future<Either<Failure, List<String>>> toggleSavedListing(String listingId);
}
