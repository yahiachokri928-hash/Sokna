import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import '../../../../core/exceptions/exceptions.dart';
import '../models/listing_model.dart';

abstract class ListingDataSource {
  Future<List<ListingModel>> getListings();
  Future<List<ListingModel>> searchListings(String query);
  Future<void> addListing(ListingModel listing);
}

class ListingDataSourceImpl implements ListingDataSource {
  static const String remoteUrl =
      'https://raw.githubusercontent.com/yahiachokri928-hash/Sokna/main/assets/data/listings.json';
  static const String localAssetPath = 'assets/data/listings.json';

  final http.Client client;

  // In-memory storage for newly added listings during the app session
  final List<ListingModel> _sessionListings = [];

  ListingDataSourceImpl({required this.client});

  @override
  Future<List<ListingModel>> getListings() async {
    List<ListingModel> baseListings = [];

    try {
      final response = await client
          .get(Uri.parse(remoteUrl))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
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

    // Merge session-added listings (most recent first)
    final combined = <ListingModel>[
      ..._sessionListings,
      ...baseListings.where(
        (base) => !_sessionListings.any((added) => added.id == base.id),
      ),
    ];

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
    _sessionListings.insert(0, listing);
  }
}
