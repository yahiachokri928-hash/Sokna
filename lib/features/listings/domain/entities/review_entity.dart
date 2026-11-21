import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String listingId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.listingId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        listingId,
        userId,
        userName,
        userAvatarUrl,
        rating,
        comment,
        createdAt,
      ];
}
