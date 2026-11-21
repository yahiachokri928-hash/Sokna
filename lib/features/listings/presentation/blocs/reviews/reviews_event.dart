part of 'reviews_bloc.dart';

abstract class ReviewsEvent extends Equatable {
  const ReviewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadReviewsEvent extends ReviewsEvent {
  final String listingId;

  const LoadReviewsEvent(this.listingId);

  @override
  List<Object?> get props => [listingId];
}

class SubmitReviewEvent extends ReviewsEvent {
  final ReviewEntity review;

  const SubmitReviewEvent(this.review);

  @override
  List<Object?> get props => [review];
}
