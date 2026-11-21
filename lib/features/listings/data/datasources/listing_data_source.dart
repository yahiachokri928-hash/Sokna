import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  static const String cachedCloudListingsKey = 'CACHED_CLOUD_LISTINGS';

  final http.Client client;
  final FirestoreService? firestoreService;
  final AuthService? authService;
  final SharedPreferences? sharedPreferences;

  // In-memory storage for newly added listings during the app session
  final List<ListingModel> _sessionListings = [];

  ListingDataSourceImpl({
    required this.client,
    this.firestoreService,
    this.authService,
    this.sharedPreferences,
  });

  @override
  Future<List<ListingModel>> getListings() async {
    List<ListingModel> cloudListings = [];

    // 1. Fetch exclusively from Cloud Firestore as primary source
    if (firestoreService != null) {
      try {
        final snapshot = await firestoreService!.listingsCollection
            .orderBy('createdAt', descending: true)
            .get();

        cloudListings = snapshot.docs
            .map((doc) => ListingModel.fromFirestore(doc))
            .toList();

        // 2. Cache the fetched Firestore listings in SharedPreferences
        if (sharedPreferences != null && cloudListings.isNotEmpty) {
          final jsonList = cloudListings
              .map((listing) => jsonEncode(listing.toJson()))
              .toList();
          await sharedPreferences!
              .setStringList(cachedCloudListingsKey, jsonList);
        }
      } catch (_) {
        // Fallback to local cache when offline or if query fails (ENF3)
        cloudListings = _loadFromCache();
      }
    } else {
      cloudListings = _loadFromCache();
    }

    // 3. Merge: session listings + cloud/cached listings without duplicates
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

    return combined;
  }

  List<ListingModel> _loadFromCache() {
    if (sharedPreferences == null) return [];
    try {
      final cachedList =
          sharedPreferences!.getStringList(cachedCloudListingsKey);
      if (cachedList == null || cachedList.isEmpty) return [];

      return cachedList
          .map((item) =>
              ListingModel.fromJson(jsonDecode(item) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
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

    String? phone = listing.ownerPhone;
    String? avatarUrl = listing.ownerAvatarUrl;

    // Attach ownerPhone and ownerAvatarUrl from users/{uid} profile if available
    if (firestoreService != null) {
      try {
        final userDoc =
            await firestoreService!.usersCollection.doc(user.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data()!;
          phone ??= data['phone'] as String?;
          avatarUrl ??= data['profilURL'] as String?;
        }
      } catch (_) {
        // Fallback to Auth properties
      }
    }

    phone ??= user.phoneNumber;
    avatarUrl ??= user.photoURL;

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
      ownerPhone: phone,
      ownerAvatarUrl: avatarUrl,
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
