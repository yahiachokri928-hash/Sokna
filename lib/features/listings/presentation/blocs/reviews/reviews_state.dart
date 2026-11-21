part of 'reviews_bloc.dart';

abstract class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object?> get props => [];
}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<ReviewEntity> reviews;

  const ReviewsLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class ReviewSubmitting extends ReviewsState {}

class ReviewSubmittedSuccess extends ReviewsState {
  final String message;
  final String listingId;

  const ReviewSubmittedSuccess({
    required this.message,
    required this.listingId,
  });

  @override
  List<Object?> get props => [message, listingId];
}

class ReviewsError extends ReviewsState {
  final String message;

  const ReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}
