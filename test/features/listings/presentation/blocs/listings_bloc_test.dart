import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/failures/failures.dart';
import 'package:sokna/features/listings/domain/entities/listing_entity.dart';
import 'package:sokna/features/listings/domain/repositories/listing_repository.dart';
import 'package:sokna/features/listings/domain/usecases/add_listing.dart';
import 'package:sokna/features/listings/domain/usecases/delete_listing.dart';
import 'package:sokna/features/listings/domain/usecases/get_listings.dart';
import 'package:sokna/features/listings/presentation/blocs/listings/listings_bloc.dart';

class MockListingRepository implements ListingRepository {
  List<ListingEntity> listings = [
    const ListingEntity(
      id: 'sokna_001',
      title: 'Studio Sidi Bou Said',
      city: 'Sidi Bou Said',
      address: 'Rue Habib Thameur',
      propertyType: 'Studio',
      price: 900,
      rooms: 1,
      surface: 45.0,
      isFurnished: true,
      hasParking: false,
      imagePath: 'https://example.com/img.jpg',
      rating: 4.8,
      reviewCount: 10,
      ownerName: 'Yahia',
      availableFrom: '2026-06-01',
      description: 'Charmant studio',
      ownerId: 'user_123',
    ),
    const ListingEntity(
      id: 'sokna_002',
      title: 'Appartement Ennasr',
      city: 'Ariana',
      address: 'Avenue Hedi Nouira',
      propertyType: 'Appartement',
      price: 1300,
      rooms: 3,
      surface: 120.0,
      isFurnished: false,
      hasParking: true,
      imagePath: 'https://example.com/img2.jpg',
      rating: 4.5,
      reviewCount: 5,
      ownerName: 'Ali',
      availableFrom: '2026-07-01',
      description: 'Grand appartement',
      ownerId: 'user_456',
    ),
  ];

  @override
  Future<Either<Failure, List<ListingEntity>>> getListings() async =>
      Right(List.from(listings));

  @override
  Future<Either<Failure, List<ListingEntity>>> searchListings(String query) async =>
      Right(List.from(listings));

  @override
  Future<Either<Failure, Unit>> addListing(ListingEntity listing) async {
    listings.add(listing);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> deleteListing(String listingId) async {
    listings.removeWhere((item) => item.id == listingId);
    return const Right(unit);
  }
}

void main() {
  late MockListingRepository mockRepository;
  late GetListingsUseCase getListingsUseCase;
  late AddListingUseCase addListingUseCase;
  late DeleteListingUseCase deleteListingUseCase;
  late ListingsBloc bloc;

  setUp(() {
    mockRepository = MockListingRepository();
    getListingsUseCase = GetListingsUseCase(mockRepository);
    addListingUseCase = AddListingUseCase(mockRepository);
    deleteListingUseCase = DeleteListingUseCase(mockRepository);
    bloc = ListingsBloc(
      getListingsUseCase: getListingsUseCase,
      addListingUseCase: addListingUseCase,
      deleteListingUseCase: deleteListingUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('DeleteListingEvent removes listing from loaded state', () async {
    bloc.add(const GetListingsEvent());
    await Future.delayed(const Duration(milliseconds: 50));

    expect(bloc.state, isA<ListingsLoaded>());
    final loaded = bloc.state as ListingsLoaded;
    expect(loaded.allListings.length, 2);

    bloc.add(const DeleteListingEvent('sokna_001'));
    await Future.delayed(const Duration(milliseconds: 50));

    final updatedState = bloc.state as ListingsLoaded;
    expect(updatedState.allListings.length, 1);
    expect(updatedState.allListings.any((l) => l.id == 'sokna_001'), isFalse);
  });
}
