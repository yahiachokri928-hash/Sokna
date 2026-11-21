import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/features/listings/data/models/review_model.dart';
import 'package:sokna/features/listings/domain/entities/review_entity.dart';

void main() {
  final testDate = DateTime(2026, 11, 21, 15, 0, 0);

  final testReviewModel = ReviewModel(
    id: 'user_123',
    listingId: 'sokna_001',
    userId: 'user_123',
    userName: 'Ahmed Ben Salah',
    userAvatarUrl: 'https://example.com/avatar.jpg',
    rating: 4.8,
    comment: 'Super appartement, très propre et bien situé !',
    createdAt: testDate,
  );

  final testJson = {
    'id': 'user_123',
    'listingId': 'sokna_001',
    'userId': 'user_123',
    'userName': 'Ahmed Ben Salah',
    'userAvatarUrl': 'https://example.com/avatar.jpg',
    'rating': 4.8,
    'comment': 'Super appartement, très propre et bien situé !',
    'createdAt': testDate.toIso8601String(),
  };

  test('ReviewModel should be a subclass of ReviewEntity', () {
    expect(testReviewModel, isA<ReviewEntity>());
  });

  group('fromJson', () {
    test('should return a valid ReviewModel from JSON', () {
      final result = ReviewModel.fromJson(testJson);

      expect(result.id, testReviewModel.id);
      expect(result.listingId, testReviewModel.listingId);
      expect(result.userId, testReviewModel.userId);
      expect(result.userName, testReviewModel.userName);
      expect(result.userAvatarUrl, testReviewModel.userAvatarUrl);
      expect(result.rating, testReviewModel.rating);
      expect(result.comment, testReviewModel.comment);
      expect(result.createdAt, testReviewModel.createdAt);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing correct review fields', () {
      final result = testReviewModel.toJson();

      expect(result, equals(testJson));
    });
  });

  group('fromEntity', () {
    test('should convert a ReviewEntity to ReviewModel', () {
      final entity = ReviewEntity(
        id: 'user_123',
        listingId: 'sokna_001',
        userId: 'user_123',
        userName: 'Ahmed Ben Salah',
        userAvatarUrl: 'https://example.com/avatar.jpg',
        rating: 4.8,
        comment: 'Super appartement, très propre et bien situé !',
        createdAt: testDate,
      );

      final result = ReviewModel.fromEntity(entity);

      expect(result.id, entity.id);
      expect(result.listingId, entity.listingId);
      expect(result.rating, entity.rating);
      expect(result.comment, entity.comment);
    });
  });
}
