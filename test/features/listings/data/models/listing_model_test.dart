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
    rating: 4.9,
    reviewCount: 18,
    ownerName: 'Karim Ben Amor',
    availableFrom: '2026-12-01',
    description: 'Magnifique appartement S+2 haut standing.',
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
    'rating': 4.9,
    'reviewCount': 18,
    'ownerName': 'Karim Ben Amor',
    'availableFrom': '2026-12-01',
    'description': 'Magnifique appartement S+2 haut standing.',
  };

  test('ListingModel should be a subclass of ListingEntity', () {
    expect(testListingModel, isA<ListingEntity>());
  });

  group('fromJson', () {
    test('should return a valid ListingModel when JSON is valid with all 16 fields', () {
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
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
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
        rating: 4.9,
        reviewCount: 18,
        ownerName: 'Karim Ben Amor',
        availableFrom: '2026-12-01',
        description: 'Magnifique appartement S+2 haut standing.',
      );

      final result = ListingModel.fromEntity(entity);

      expect(result, equals(testListingModel));
    });
  });
}
