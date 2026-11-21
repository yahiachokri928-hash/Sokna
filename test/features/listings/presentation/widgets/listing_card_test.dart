import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sokna/core/strings/messages.dart';
import 'package:sokna/features/listings/domain/entities/listing_entity.dart';
import 'package:sokna/features/listings/presentation/widgets/listing_card.dart';

void main() {
  const testListing = ListingEntity(
    id: 'sokna_001',
    title: 'S+2 moderne vue mer',
    city: 'La Marsa',
    address: 'Avenue Habib Bourguiba',
    propertyType: 'Appartement',
    price: 1650,
    rooms: 3,
    surface: 110.0,
    isFurnished: true,
    hasParking: true,
    imagePath: 'https://example.com/photo.jpg',
    rating: 4.9,
    reviewCount: 18,
    ownerName: 'Karim Ben Amor',
    availableFrom: '2026-12-01',
    description: 'Magnifique appartement.',
  );

  testWidgets('ListingCard renders title, city, price and handles tap', (WidgetTester tester) async {
    bool tapped = false;
    bool favoriteToggled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListingCard(
            listing: testListing,
            isFavorite: false,
            onTap: () {
              tapped = true;
            },
            onFavoriteToggle: () {
              favoriteToggled = true;
            },
          ),
        ),
      ),
    );

    // Verify title, city, and formatted price
    expect(find.text('S+2 moderne vue mer'), findsOneWidget);
    expect(find.textContaining('La Marsa'), findsOneWidget);
    expect(find.text('1650 $DETAIL_PRICE_UNIT'), findsOneWidget);
    expect(find.text(LISTING_CARD_VERIFIED), findsOneWidget);

    // Tap on card
    await tester.tap(find.text('S+2 moderne vue mer'));
    expect(tapped, isTrue);

    // Tap favorite icon
    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    expect(favoriteToggled, isTrue);
  });
}
