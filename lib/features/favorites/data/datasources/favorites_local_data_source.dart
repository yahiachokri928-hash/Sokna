import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/exceptions/exceptions.dart';

abstract class FavoritesLocalDataSource {
  Future<List<String>> getSavedListingIds();
  Future<List<String>> toggleSavedListing(String listingId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  static const String savedListingsKey = 'saved_listing_ids';

  final SharedPreferences sharedPreferences;

  FavoritesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<String>> getSavedListingIds() async {
    try {
      final List<String>? ids = sharedPreferences.getStringList(savedListingsKey);
      return ids ?? [];
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<String>> toggleSavedListing(String listingId) async {
    try {
      final currentList = await getSavedListingIds();
      final updatedSet = currentList.toSet();

      if (updatedSet.contains(listingId)) {
        updatedSet.remove(listingId);
      } else {
        updatedSet.add(listingId);
      }

      final updatedList = updatedSet.toList();
      await sharedPreferences.setStringList(savedListingsKey, updatedList);
      return updatedList;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
