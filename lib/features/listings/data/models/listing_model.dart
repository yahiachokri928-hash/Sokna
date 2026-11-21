import '../../domain/entities/listing_entity.dart';

class ListingModel extends ListingEntity {
  const ListingModel({
    required super.id,
    required super.title,
    required super.city,
    required super.address,
    required super.propertyType,
    required super.price,
    required super.rooms,
    required super.surface,
    required super.isFurnished,
    required super.hasParking,
    required super.imagePath,
    required super.rating,
    required super.reviewCount,
    required super.ownerName,
    required super.availableFrom,
    required super.description,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      city: json['city'] as String? ?? '',
      address: json['address'] as String? ?? '',
      propertyType: json['propertyType'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      rooms: (json['rooms'] as num?)?.toInt() ?? 1,
      surface: (json['surface'] as num?)?.toDouble() ?? 0.0,
      isFurnished: json['isFurnished'] as bool? ?? false,
      hasParking: json['hasParking'] as bool? ?? false,
      imagePath: json['imagePath'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      ownerName: json['ownerName'] as String? ?? '',
      availableFrom: json['availableFrom'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'city': city,
      'address': address,
      'propertyType': propertyType,
      'price': price,
      'rooms': rooms,
      'surface': surface,
      'isFurnished': isFurnished,
      'hasParking': hasParking,
      'imagePath': imagePath,
      'rating': rating,
      'reviewCount': reviewCount,
      'ownerName': ownerName,
      'availableFrom': availableFrom,
      'description': description,
    };
  }

  factory ListingModel.fromEntity(ListingEntity entity) {
    return ListingModel(
      id: entity.id,
      title: entity.title,
      city: entity.city,
      address: entity.address,
      propertyType: entity.propertyType,
      price: entity.price,
      rooms: entity.rooms,
      surface: entity.surface,
      isFurnished: entity.isFurnished,
      hasParking: entity.hasParking,
      imagePath: entity.imagePath,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      ownerName: entity.ownerName,
      availableFrom: entity.availableFrom,
      description: entity.description,
    );
  }
}
