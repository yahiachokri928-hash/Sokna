import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/strings/failures.dart';
import '../../../../../core/strings/messages.dart';
import '../../../domain/entities/review_entity.dart';
import '../../../domain/usecases/get_listing_reviews.dart';
import '../../../domain/usecases/submit_review.dart';

part 'reviews_event.dart';
part 'reviews_state.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final GetListingReviewsUseCase getListingReviewsUseCase;
  final SubmitReviewUseCase submitReviewUseCase;

  ReviewsBloc({
    required this.getListingReviewsUseCase,
    required this.submitReviewUseCase,
  }) : super(ReviewsInitial()) {
    on<LoadReviewsEvent>(_onLoadReviews);
    on<SubmitReviewEvent>(_onSubmitReview);
  }

  Future<void> _onLoadReviews(
    LoadReviewsEvent event,
    Emitter<ReviewsState> emit,
  ) async {
    emit(ReviewsLoading());
    final result = await getListingReviewsUseCase(event.listingId);
    result.fold(
      (failure) => emit(ReviewsError(failure.message)),
      (reviews) => emit(ReviewsLoaded(reviews)),
    );
  }

  Future<void> _onSubmitReview(
    SubmitReviewEvent event,
    Emitter<ReviewsState> emit,
  ) async {
    emit(ReviewSubmitting());
    final result = await submitReviewUseCase(event.review);
    result.fold(
      (failure) => emit(ReviewsError(failure.message.isNotEmpty
          ? failure.message
          : REVIEW_SUBMISSION_FAILURE_MESSAGE)),
      (_) => emit(ReviewSubmittedSuccess(
        message: DETAIL_REVIEW_SUCCESS,
        listingId: event.review.listingId,
      )),
    );
  }
}
