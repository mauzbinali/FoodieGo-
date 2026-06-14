import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/storage/hive_service.dart';
import '../models/restaurant_model.dart';
import 'demo_data.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  return RestaurantRepository(
    firestore: Firebase.apps.isEmpty ? null : FirebaseFirestore.instance,
    hive: ref.watch(hiveServiceProvider),
  );
});

class RestaurantRepository {
  final FirebaseFirestore? _firestore;
  final HiveService _hive;

  RestaurantRepository({
    required FirebaseFirestore? firestore,
    required HiveService hive,
  }) : _firestore = firestore,
       _hive = hive;

  CollectionReference<Map<String, dynamic>>? get _collection =>
      _firestore?.collection(AppConstants.restaurantsCollection);

  Future<List<RestaurantModel>> getAllRestaurants({
    bool forceRefresh = false,
  }) async {
    if (_collection == null) return DemoData.restaurants;

    try {
      if (!forceRefresh && _hive.isRestaurantCacheValid()) {
        final cached = _hive.getCachedRestaurants();
        if (cached.isNotEmpty) {
          return cached.map(RestaurantModel.fromMap).toList();
        }
      }
      final snapshot = await _collection!
          .orderBy('createdAt', descending: true)
          .get();
      final restaurants = snapshot.docs
          .map(RestaurantModel.fromFirestore)
          .toList();
      await _hive.cacheRestaurants(restaurants.map((r) => r.toMap()).toList());
      return restaurants;
    } catch (_) {
      final cached = _hive.getCachedRestaurants();
      if (cached.isNotEmpty) {
        return cached.map(RestaurantModel.fromMap).toList();
      }
      return DemoData.restaurants;
    }
  }

  Future<RestaurantModel?> getRestaurantById(String id) async {
    if (_collection == null) {
      return DemoData.restaurants.where((r) => r.id == id).firstOrNull;
    }
    final doc = await _collection!.doc(id).get();
    return doc.exists ? RestaurantModel.fromFirestore(doc) : null;
  }

  Stream<RestaurantModel?> getRestaurantStream(String id) {
    if (_collection == null) {
      return Stream.value(
        DemoData.restaurants.where((r) => r.id == id).firstOrNull,
      );
    }
    return _collection!
        .doc(id)
        .snapshots()
        .map((doc) => doc.exists ? RestaurantModel.fromFirestore(doc) : null);
  }

  Future<List<RestaurantModel>> getFeaturedRestaurants() async {
    final all = await getAllRestaurants();
    return all.where((r) => r.isFeatured && r.isOpen).toList();
  }

  Future<List<RestaurantModel>> getPopularRestaurants() async {
    final all = await getAllRestaurants();
    return all.where((r) => r.isPopular).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }

  Future<List<RestaurantModel>> getTopRatedRestaurants() async {
    final all = await getAllRestaurants();
    return all..sort((a, b) => b.rating.compareTo(a.rating));
  }

  Future<List<RestaurantModel>> getRestaurantsByCategory(
    String category,
  ) async {
    final all = await getAllRestaurants();
    final lower = category.toLowerCase();
    return all
        .where((r) => r.categories.any((c) => c.toLowerCase() == lower))
        .toList();
  }

  Future<List<RestaurantModel>> searchRestaurants(String query) async {
    final lower = query.toLowerCase();
    final all = await getAllRestaurants();
    return all
        .where(
          (r) =>
              r.name.toLowerCase().contains(lower) ||
              r.address.toLowerCase().contains(lower) ||
              r.categories.any((c) => c.toLowerCase().contains(lower)),
        )
        .toList();
  }

  Future<List<RestaurantModel>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  }) async {
    final all = await getAllRestaurants();
    return all
        .map(
          (r) => r.copyWith(
            distance: _distanceKm(latitude, longitude, r.latitude, r.longitude),
          ),
        )
        .where((r) => r.distance <= radiusKm)
        .toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
  }

  Future<RestaurantModel> createRestaurant(RestaurantModel restaurant) async {
    if (_collection == null) return restaurant;
    await _collection!.doc(restaurant.id).set(restaurant.toMap());
    return restaurant;
  }

  Future<void> updateRestaurant(RestaurantModel restaurant) async {
    if (_collection == null) return;
    await _collection!.doc(restaurant.id).update(restaurant.toMap());
  }

  Future<void> deleteRestaurant(String id) async {
    if (_collection == null) return;
    await _collection!.doc(id).delete();
  }

  Future<RestaurantModel?> getOwnerRestaurant(String ownerId) async {
    final all = await getAllRestaurants();
    return all.where((r) => r.ownerId == ownerId).firstOrNull;
  }

  double _distanceKm(double lat1, double lng1, double lat2, double lng2) {
    const earthRadiusKm = 6371;
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    return earthRadiusKm * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _toRadians(double degrees) => degrees * pi / 180;
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
