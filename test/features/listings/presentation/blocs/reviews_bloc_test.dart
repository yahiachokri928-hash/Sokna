import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/failures/failures.dart';
import 'package:sokna/features/listings/domain/entities/listing_entity.dart';
import 'package:sokna/features/listings/domain/entities/review_entity.dart';
import 'package:sokna/features/listings/domain/repositories/listing_repository.dart';
import 'package:sokna/features/listings/domain/usecases/get_listing_reviews.dart';
import 'package:sokna/features/listings/domain/usecases/submit_review.dart';
import 'package:sokna/features/listings/presentation/blocs/reviews/reviews_bloc.dart';

class MockReviewsRepository implements ListingRepository {
  List<ReviewEntity> reviews = [];

  @override
  Future<Either<Failure, List<ListingEntity>>> getListings() async => const Right([]);

  @override
  Future<Either<Failure, List<ListingEntity>>> searchListings(String query) async => const Right([]);

  @override
  Future<Either<Failure, Unit>> addListing(ListingEntity listing) async => const Right(unit);

  @override
  Future<Either<Failure, Unit>> deleteListing(String listingId) async => const Right(unit);

  @override
  Future<Either<Failure, List<ReviewEntity>>> getListingReviews(String listingId) async =>
      Right(reviews);

  @override
  Future<Either<Failure, Unit>> submitReview(ReviewEntity review) async {
    reviews.add(review);
    return const Right(unit);
  }
}

void main() {
  late MockReviewsRepository mockRepository;
  late GetListingReviewsUseCase getListingReviewsUseCase;
  late SubmitReviewUseCase submitReviewUseCase;
  late ReviewsBloc reviewsBloc;

  setUp(() {
    mockRepository = MockReviewsRepository();
    getListingReviewsUseCase = GetListingReviewsUseCase(mockRepository);
    submitReviewUseCase = SubmitReviewUseCase(mockRepository);
    reviewsBloc = ReviewsBloc(
      getListingReviewsUseCase: getListingReviewsUseCase,
      submitReviewUseCase: submitReviewUseCase,
    );
  });

  tearDown(() {
    reviewsBloc.close();
  });

  test('initial state should be ReviewsInitial', () {
    expect(reviewsBloc.state, equals(ReviewsInitial()));
  });

  test('LoadReviewsEvent emits [ReviewsLoading, ReviewsLoaded]', () async {
    final testReview = ReviewEntity(
      id: 'rev_1',
      listingId: 'listing_001',
      userId: 'user_1',
      userName: 'Sarra',
      rating: 5.0,
      comment: 'Top location !',
      createdAt: DateTime.now(),
    );
    mockRepository.reviews = [testReview];

    reviewsBloc.add(const LoadReviewsEvent('listing_001'));

    await expectLater(
      reviewsBloc.stream,
      emitsInOrder([
        ReviewsLoading(),
        ReviewsLoaded([testReview]),
      ]),
    );
  });

  test('SubmitReviewEvent emits [ReviewSubmitting, ReviewSubmittedSuccess]', () async {
    final testReview = ReviewEntity(
      id: 'rev_2',
      listingId: 'listing_001',
      userId: 'user_2',
      userName: 'Khaled',
      rating: 4.5,
      comment: 'Très bon séjour',
      createdAt: DateTime.now(),
    );

    reviewsBloc.add(SubmitReviewEvent(testReview));

    await expectLater(
      reviewsBloc.stream,
      emitsInOrder([
        ReviewSubmitting(),
        isA<ReviewSubmittedSuccess>(),
      ]),
    );
  });
}
