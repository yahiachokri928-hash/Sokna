import 'package:equatable/equatable.dart';

class ListingEntity extends Equatable {
  final String id;
  final String title;
  final String city;
  final String address;
  final String propertyType;
  final int price;
  final int rooms;
  final double surface;
  final bool isFurnished;
  final bool hasParking;
  final String imagePath;
  final List<String> imageUrls;
  final double rating;
  final int reviewCount;
  final String ownerName;
  final String availableFrom;
  final String description;
  final String? ownerId;
  final String? ownerPhone;
  final String? ownerAvatarUrl;

  const ListingEntity({
    required this.id,
    required this.title,
    required this.city,
    required this.address,
    required this.propertyType,
    required this.price,
    required this.rooms,
    required this.surface,
    required this.isFurnished,
    required this.hasParking,
    required this.imagePath,
    this.imageUrls = const [],
    required this.rating,
    required this.reviewCount,
    required this.ownerName,
    required this.availableFrom,
    required this.description,
    this.ownerId,
    this.ownerPhone,
    this.ownerAvatarUrl,
  });

  /// Returns the available images as a non-empty list, falling back to [imagePath] if [imageUrls] is empty.
  List<String> get effectiveImageUrls =>
      imageUrls.isNotEmpty ? imageUrls : (imagePath.isNotEmpty ? [imagePath] : const []);

  @override
  List<Object?> get props => [
        id,
        title,
        city,
        address,
        propertyType,
        price,
        rooms,
        surface,
        isFurnished,
        hasParking,
        imagePath,
        imageUrls,
        rating,
        reviewCount,
        ownerName,
        availableFrom,
        description,
        ownerId,
        ownerPhone,
        ownerAvatarUrl,
      ];
}
