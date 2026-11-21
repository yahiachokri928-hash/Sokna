import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../entities/review_entity.dart';
import '../repositories/listing_repository.dart';

class SubmitReviewUseCase {
  final ListingRepository repository;

  SubmitReviewUseCase(this.repository);

  Future<Either<Failure, Unit>> call(ReviewEntity review) async {
    return await repository.submitReview(review);
  }
}
