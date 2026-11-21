import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/firebase/auth_service.dart';
import '../../../../core/firebase/firestore_service.dart';
import '../models/listing_model.dart';

abstract class ListingDataSource {
  Future<List<ListingModel>> getListings();
  Future<List<ListingModel>> searchListings(String query);
  Future<void> addListing(ListingModel listing);
  Future<void> deleteListing(String listingId);
}

class ListingDataSourceImpl implements ListingDataSource {
  static const String remoteUrl =
      'https://raw.githubusercontent.com/yahiachokri928-hash/Sokna/main/assets/data/listings.json';
  static const String localAssetPath = 'assets/data/listings.json';

  final http.Client client;
  final FirestoreService? firestoreService;
  final AuthService? authService;

  // In-memory storage for newly added listings during the app session
  final List<ListingModel> _sessionListings = [];

  ListingDataSourceImpl({
    required this.client,
    this.firestoreService,
    this.authService,
  });

  @override
  Future<List<ListingModel>> getListings() async {
    List<ListingModel> baseListings = [];

    // 1. Fetch base listings from REST / local asset
    try {
      final response = await client
          .get(Uri.parse(remoteUrl))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            jsonDecode(response.body) as List<dynamic>;
        baseListings = jsonList
            .map((item) => ListingModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        baseListings = await _loadFromLocalAsset();
      }
    } catch (_) {
      // Automatic offline fallback to local bundle (ENF3)
      baseListings = await _loadFromLocalAsset();
    }

    // 2. Fetch user-published listings from Cloud Firestore
    List<ListingModel> cloudListings = [];
    if (firestoreService != null) {
      try {
        final snapshot = await firestoreService!.listingsCollection.get();
        cloudListings = snapshot.docs
            .map((doc) => ListingModel.fromFirestore(doc))
            .toList();
      } catch (_) {
        // Offline resilience: ignore Firestore query failure
      }
    }

    // 3. Merge: session listings + cloud listings + base listings without duplicates
    final combined = <ListingModel>[];
    final Set<String> seenIds = {};

    for (final listing in _sessionListings) {
      if (seenIds.add(listing.id)) {
        combined.add(listing);
      }
    }

    for (final listing in cloudListings) {
      if (seenIds.add(listing.id)) {
        combined.add(listing);
      }
    }

    for (final listing in baseListings) {
      if (seenIds.add(listing.id)) {
        combined.add(listing);
      }
    }

    return combined;
  }

  Future<List<ListingModel>> _loadFromLocalAsset() async {
    try {
      final String rawString = await rootBundle.loadString(localAssetPath);
      final List<dynamic> jsonList = jsonDecode(rawString) as List<dynamic>;
      return jsonList
          .map((item) => ListingModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ListingModel>> searchListings(String query) async {
    final all = await getListings();
    if (query.trim().isEmpty) {
      return all;
    }
    final cleanQuery = query.toLowerCase().trim();
    return all.where((item) {
      return item.title.toLowerCase().contains(cleanQuery) ||
          item.city.toLowerCase().contains(cleanQuery) ||
          item.address.toLowerCase().contains(cleanQuery) ||
          item.propertyType.toLowerCase().contains(cleanQuery);
    }).toList();
  }

  @override
  Future<void> addListing(ListingModel listing) async {
    final user = authService?.currentUser;
    if (user == null) {
      throw const AuthException('AUTH_REQUIRED');
    }

    final listingWithOwner = ListingModel(
      id: listing.id,
      title: listing.title,
      city: listing.city,
      address: listing.address,
      propertyType: listing.propertyType,
      price: listing.price,
      rooms: listing.rooms,
      surface: listing.surface,
      isFurnished: listing.isFurnished,
      hasParking: listing.hasParking,
      imagePath: listing.imagePath,
      rating: listing.rating,
      reviewCount: listing.reviewCount,
      ownerName: listing.ownerName.isNotEmpty
          ? listing.ownerName
          : (user.displayName ?? 'Propriétaire'),
      availableFrom: listing.availableFrom,
      description: listing.description,
      ownerId: user.uid,
    );

    if (firestoreService != null) {
      await firestoreService!.listingsCollection
          .doc(listingWithOwner.id)
          .set(listingWithOwner.toFirestore());
    }

    _sessionListings.removeWhere((item) => item.id == listingWithOwner.id);
    _sessionListings.insert(0, listingWithOwner);
  }

  @override
  Future<void> deleteListing(String listingId) async {
    if (firestoreService != null) {
      await firestoreService!.listingsCollection.doc(listingId).delete();
    }
    _sessionListings.removeWhere((item) => item.id == listingId);
  }
}
