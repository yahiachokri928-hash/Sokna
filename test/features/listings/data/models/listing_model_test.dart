import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/features/listings/data/models/listing_model.dart';
import 'package:sokna/features/listings/domain/entities/listing_entity.dart';

void main() {
  const testListingModel = ListingModel(
    id: 'sokna_001',
    title: 'S+2 moderne avec vue panoramique sur mer',
    city: 'La Marsa',
    address: 'Avenue Habib Bourguiba, Marsa Plage',
    propertyType: 'Appartement',
    price: 1650,
    rooms: 3,
    surface: 110.0,
    isFurnished: true,
    hasParking: true,
    imagePath: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
    imageUrls: [
      'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
      'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688',
    ],
    rating: 4.9,
    reviewCount: 18,
    ownerName: 'Karim Ben Amor',
    availableFrom: '2026-12-01',
    description: 'Magnifique appartement S+2 haut standing.',
    ownerId: 'owner_123',
    ownerPhone: '+216 20 123 456',
    ownerAvatarUrl: 'https://example.com/avatar.jpg',
  );

  final testJson = {
    'id': 'sokna_001',
    'title': 'S+2 moderne avec vue panoramique sur mer',
    'city': 'La Marsa',
    'address': 'Avenue Habib Bourguiba, Marsa Plage',
    'propertyType': 'Appartement',
    'price': 1650,
    'rooms': 3,
    'surface': 110.0,
    'isFurnished': true,
    'hasParking': true,
    'imagePath': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
    'imageUrls': [
      'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
      'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688',
    ],
    'rating': 4.9,
    'reviewCount': 18,
    'ownerName': 'Karim Ben Amor',
    'availableFrom': '2026-12-01',
    'description': 'Magnifique appartement S+2 haut standing.',
    'ownerId': 'owner_123',
    'ownerPhone': '+216 20 123 456',
    'ownerAvatarUrl': 'https://example.com/avatar.jpg',
  };

  test('ListingModel should be a subclass of ListingEntity', () {
    expect(testListingModel, isA<ListingEntity>());
  });

  group('fromJson', () {
    test('should return a valid ListingModel when JSON is valid with all fields', () {
      final result = ListingModel.fromJson(testJson);

      expect(result, equals(testListingModel));
      expect(result.id, 'sokna_001');
      expect(result.title, 'S+2 moderne avec vue panoramique sur mer');
      expect(result.city, 'La Marsa');
      expect(result.address, 'Avenue Habib Bourguiba, Marsa Plage');
      expect(result.propertyType, 'Appartement');
      expect(result.price, 1650);
      expect(result.rooms, 3);
      expect(result.surface, 110.0);
      expect(result.isFurnished, true);
      expect(result.hasParking, true);
      expect(result.imagePath, 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267');
      expect(result.rating, 4.9);
      expect(result.reviewCount, 18);
      expect(result.ownerName, 'Karim Ben Amor');
      expect(result.availableFrom, '2026-12-01');
      expect(result.description, 'Magnifique appartement S+2 haut standing.');
      expect(result.ownerId, 'owner_123');
      expect(result.ownerPhone, '+216 20 123 456');
      expect(result.ownerAvatarUrl, 'https://example.com/avatar.jpg');
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data including ownerId and metadata', () {
      final result = testListingModel.toJson();

      expect(result, testJson);
    });
  });

  group('fromEntity', () {
    test('should convert a ListingEntity to a ListingModel', () {
      const entity = ListingEntity(
        id: 'sokna_001',
        title: 'S+2 moderne avec vue panoramique sur mer',
        city: 'La Marsa',
        address: 'Avenue Habib Bourguiba, Marsa Plage',
        propertyType: 'Appartement',
        price: 1650,
        rooms: 3,
        surface: 110.0,
        isFurnished: true,
        hasParking: true,
        imagePath: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
        imageUrls: [
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688',
        ],
        rating: 4.9,
        reviewCount: 18,
        ownerName: 'Karim Ben Amor',
        availableFrom: '2026-12-01',
        description: 'Magnifique appartement S+2 haut standing.',
        ownerId: 'owner_123',
        ownerPhone: '+216 20 123 456',
        ownerAvatarUrl: 'https://example.com/avatar.jpg',
      );

      final result = ListingModel.fromEntity(entity);

      expect(result, equals(testListingModel));
    });
  });

  group('toFirestore', () {
    test('should contain valid firestore map representation', () {
      final map = testListingModel.toFirestore();
      expect(map['id'], 'sokna_001');
      expect(map['imageUrls'], testListingModel.imageUrls);
      expect(map['imagePath'], testListingModel.imagePath);
      expect(map['ownerId'], 'owner_123');
      expect(map['ownerPhone'], '+216 20 123 456');
      expect(map['ownerAvatarUrl'], 'https://example.com/avatar.jpg');
      expect(map.containsKey('createdAt'), isTrue);
    });
  });

  group('effectiveImageUrls and backward compatibility', () {
    test('should return imageUrls when present', () {
      expect(testListingModel.effectiveImageUrls, [
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688',
      ]);
    });

    test('should fallback to [imagePath] when imageUrls is empty', () {
      const singlePhotoModel = ListingModel(
        id: 'sokna_single',
        title: 'Studio',
        city: 'Tunis',
        address: 'Centre Ville',
        propertyType: 'Studio',
        price: 800,
        rooms: 1,
        surface: 45.0,
        isFurnished: false,
        hasParking: false,
        imagePath: 'https://example.com/single.jpg',
        imageUrls: [],
        rating: 4.5,
        reviewCount: 3,
        ownerName: 'Ali',
        availableFrom: '2026-11-01',
        description: 'Cozy studio',
      );

      expect(singlePhotoModel.effectiveImageUrls, ['https://example.com/single.jpg']);
    });

    test('fromJson should populate imageUrls from imagePath when imageUrls is missing', () {
      final legacyJson = {
        'id': 'legacy_01',
        'title': 'Ancien listing',
        'city': 'Sousse',
        'address': 'Kantaoui',
        'propertyType': 'Appartement',
        'price': 1200,
        'rooms': 2,
        'surface:': 80.0,
        'imagePath': 'https://example.com/legacy.jpg',
        'rating': 4.0,
        'reviewCount': 2,
        'ownerName': 'Sonia',
        'availableFrom': '2026-10-01',
        'description': 'Bel appartement',
      };

      final parsed = ListingModel.fromJson(legacyJson);
      expect(parsed.imageUrls, ['https://example.com/legacy.jpg']);
      expect(parsed.effectiveImageUrls, ['https://example.com/legacy.jpg']);
    });
  });
}
