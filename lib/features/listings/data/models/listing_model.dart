import 'package:cloud_firestore/cloud_firestore.dart';
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
    super.ownerId,
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
      ownerId: json['ownerId'] as String?,
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
      'ownerId': ownerId,
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
      ownerId: entity.ownerId,
    );
  }

  factory ListingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ListingModel(
      id: (data['id'] as String?) ?? doc.id,
      title: (data['title'] as String?) ?? '',
      city: (data['city'] as String?) ?? '',
      address: (data['address'] as String?) ?? '',
      propertyType: (data['propertyType'] as String?) ?? '',
      price: (data['price'] as num?)?.toInt() ?? 0,
      rooms: (data['rooms'] as num?)?.toInt() ?? 1,
      surface: (data['surface'] as num?)?.toDouble() ?? 0.0,
      isFurnished: (data['isFurnished'] as bool?) ?? false,
      hasParking: (data['hasParking'] as bool?) ?? false,
      imagePath: (data['imagePath'] as String?) ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
      ownerName: (data['ownerName'] as String?) ?? '',
      availableFrom: (data['availableFrom'] as String?) ?? '',
      description: (data['description'] as String?) ?? '',
      ownerId: data['ownerId'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
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
      'ownerId': ownerId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
