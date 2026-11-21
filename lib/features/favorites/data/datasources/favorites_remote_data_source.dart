import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firebase/firestore_service.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<String>> getSavedListingIds(String uid);
  Future<List<String>> toggleSavedListing(String uid, String listingId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final FirestoreService firestoreService;

  FavoritesRemoteDataSourceImpl({required this.firestoreService});

  @override
  Future<List<String>> getSavedListingIds(String uid) async {
    final doc = await firestoreService.usersCollection.doc(uid).get();
    if (!doc.exists || doc.data() == null) {
      return [];
    }

    final data = doc.data()!;
    final rawIds = data['savedListingIds'];
    if (rawIds is List) {
      return rawIds.map((e) => e.toString()).toSet().toList();
    }

    return [];
  }

  @override
  Future<List<String>> toggleSavedListing(String uid, String listingId) async {
    final docRef = firestoreService.usersCollection.doc(uid);
    final currentList = await getSavedListingIds(uid);
    final updatedSet = currentList.toSet();

    if (updatedSet.contains(listingId)) {
      await docRef.set({
        'savedListingIds': FieldValue.arrayRemove([listingId]),
      }, SetOptions(merge: true));
      updatedSet.remove(listingId);
    } else {
      await docRef.set({
        'savedListingIds': FieldValue.arrayUnion([listingId]),
      }, SetOptions(merge: true));
      updatedSet.add(listingId);
    }

    return updatedSet.toList();
  }
}
