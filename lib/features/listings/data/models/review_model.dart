import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.listingId,
    required super.userId,
    required super.userName,
    super.userAvatarUrl,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    if (json['createdAt'] is Timestamp) {
      parsedDate = (json['createdAt'] as Timestamp).toDate();
    } else if (json['createdAt'] is String) {
      parsedDate = DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return ReviewModel(
      id: json['id'] as String? ?? '',
      listingId: json['listingId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userAvatarUrl: json['userAvatarUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      comment: json['comment'] as String? ?? '',
      createdAt: parsedDate,
    );
  }

  factory ReviewModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    DateTime parsedDate = DateTime.now();
    final rawDate = data['createdAt'];
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    }

    return ReviewModel(
      id: doc.id,
      listingId: data['listingId'] as String? ?? '',
      userId: data['userId'] as String? ?? doc.id,
      userName: data['userName'] as String? ?? '',
      userAvatarUrl: data['userAvatarUrl'] as String?,
      rating: (data['rating'] as num?)?.toDouble() ?? 5.0,
      comment: data['comment'] as String? ?? '',
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'listingId': listingId,
      'userId': userId,
      'userName': userName,
      if (userAvatarUrl != null) 'userAvatarUrl': userAvatarUrl,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listingId': listingId,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      listingId: entity.listingId,
      userId: entity.userId,
      userName: entity.userName,
      userAvatarUrl: entity.userAvatarUrl,
      rating: entity.rating,
      comment: entity.comment,
      createdAt: entity.createdAt,
    );
  }
}
