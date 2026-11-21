import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../entities/review_entity.dart';
import '../repositories/listing_repository.dart';

class GetListingReviewsUseCase {
  final ListingRepository repository;

  GetListingReviewsUseCase(this.repository);

  Future<Either<Failure, List<ReviewEntity>>> call(String listingId) async {
    return await repository.getListingReviews(listingId);
  }
}
