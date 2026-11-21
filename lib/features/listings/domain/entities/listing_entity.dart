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
  final double rating;
  final int reviewCount;
  final String ownerName;
  final String availableFrom;
  final String description;
  final String? ownerId;

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
    required this.rating,
    required this.reviewCount,
    required this.ownerName,
    required this.availableFrom,
    required this.description,
    this.ownerId,
  });

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
        rating,
        reviewCount,
        ownerName,
        availableFrom,
        description,
        ownerId,
      ];
}
