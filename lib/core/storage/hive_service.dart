import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'storage_keys.dart';

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

class HiveService {
  Box get _userBox => Hive.box(StorageKeys.userBox);
  Box get _restaurantBox => Hive.box(StorageKeys.restaurantBox);
  Box get _cartBox => Hive.box(StorageKeys.cartBox);
  Box get _settingsBox => Hive.box(StorageKeys.settingsBox);
  Box get _orderBox => Hive.box(StorageKeys.orderBox);

  Future<void> cacheUser(Map<String, dynamic> userData) =>
      _putJson(_userBox, StorageKeys.cachedUser, userData);

  Map<String, dynamic>? getCachedUser() =>
      _readMap(_userBox, StorageKeys.cachedUser);

  Future<void> clearCachedUser() => _userBox.delete(StorageKeys.cachedUser);

  Future<void> cacheRestaurants(List<Map<String, dynamic>> restaurants) async {
    await _putJson(_restaurantBox, StorageKeys.cachedRestaurants, restaurants);
    await _restaurantBox.put(
      'restaurants_cached_at',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  List<Map<String, dynamic>> getCachedRestaurants() =>
      _readMapList(_restaurantBox, StorageKeys.cachedRestaurants);

  bool isRestaurantCacheValid({int maxAgeMinutes = 30}) {
    final cachedAt = _restaurantBox.get('restaurants_cached_at') as int?;
    if (cachedAt == null) return false;
    return DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(cachedAt))
            .inMinutes <
        maxAgeMinutes;
  }

  Future<void> cacheFoods(List<Map<String, dynamic>> foods) =>
      _putJson(_restaurantBox, StorageKeys.cachedFoods, foods);

  List<Map<String, dynamic>> getCachedFoods() =>
      _readMapList(_restaurantBox, StorageKeys.cachedFoods);

  Future<void> saveCart(List<Map<String, dynamic>> cartItems) =>
      _putJson(_cartBox, StorageKeys.cachedCart, cartItems);

  List<Map<String, dynamic>> getCart() =>
      _readMapList(_cartBox, StorageKeys.cachedCart);

  Future<void> clearCart() => _cartBox.delete(StorageKeys.cachedCart);

  List<String> getFavoriteRestaurantIds() =>
      _readStringList(_userBox, StorageKeys.favoriteRestaurants);

  Future<void> saveFavoriteRestaurantIds(List<String> ids) =>
      _putJson(_userBox, StorageKeys.favoriteRestaurants, ids);

  Future<void> addFavoriteRestaurant(String id) async {
    final ids = getFavoriteRestaurantIds();
    if (!ids.contains(id)) {
      ids.add(id);
      await saveFavoriteRestaurantIds(ids);
    }
  }

  Future<void> removeFavoriteRestaurant(String id) async {
    final ids = getFavoriteRestaurantIds()..remove(id);
    await saveFavoriteRestaurantIds(ids);
  }

  List<String> getFavoriteFoodIds() =>
      _readStringList(_userBox, StorageKeys.favoriteFoods);

  Future<void> saveFavoriteFoodIds(List<String> ids) =>
      _putJson(_userBox, StorageKeys.favoriteFoods, ids);

  Future<void> addFavoriteFood(String id) async {
    final ids = getFavoriteFoodIds();
    if (!ids.contains(id)) {
      ids.add(id);
      await saveFavoriteFoodIds(ids);
    }
  }

  Future<void> removeFavoriteFood(String id) async {
    final ids = getFavoriteFoodIds()..remove(id);
    await saveFavoriteFoodIds(ids);
  }

  List<String> getRecentSearches() =>
      _readStringList(_settingsBox, StorageKeys.recentSearches);

  Future<void> addRecentSearch(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;
    final searches = getRecentSearches()
      ..removeWhere((item) => item.toLowerCase() == trimmedQuery.toLowerCase())
      ..insert(0, trimmedQuery);
    await _putJson(
      _settingsBox,
      StorageKeys.recentSearches,
      searches.take(10).toList(),
    );
  }

  Future<void> clearRecentSearches() =>
      _settingsBox.delete(StorageKeys.recentSearches);

  Future<void> cacheAddresses(List<Map<String, dynamic>> addresses) =>
      _putJson(_userBox, StorageKeys.cachedAddresses, addresses);

  List<Map<String, dynamic>> getCachedAddresses() =>
      _readMapList(_userBox, StorageKeys.cachedAddresses);

  Future<void> cacheOrders(List<Map<String, dynamic>> orders) =>
      _putJson(_orderBox, StorageKeys.recentOrders, orders);

  List<Map<String, dynamic>> getCachedOrders() =>
      _readMapList(_orderBox, StorageKeys.recentOrders);

  Future<void> put(String boxName, String key, Object? value) =>
      Hive.box(boxName).put(key, value);

  Object? get(String boxName, String key) => Hive.box(boxName).get(key);

  Future<void> delete(String boxName, String key) =>
      Hive.box(boxName).delete(key);

  Future<void> clearAllUserData() async {
    await _userBox.clear();
    await _cartBox.clear();
    await _orderBox.clear();
    debugPrint('FoodieGo local user data cleared.');
  }

  Future<void> clearAll() async {
    await _userBox.clear();
    await _restaurantBox.clear();
    await _cartBox.clear();
    await _settingsBox.clear();
    await _orderBox.clear();
  }

  Future<void> _putJson(Box box, String key, Object? value) =>
      box.put(key, jsonEncode(value));

  Map<String, dynamic>? _readMap(Box box, String key) {
    final raw = box.get(key);
    if (raw is! String) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } catch (_) {
      return null;
    }
  }

  List<Map<String, dynamic>> _readMapList(Box box, String key) {
    final raw = box.get(key);
    if (raw is! String) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (_) {
      return [];
    }
  }

  List<String> _readStringList(Box box, String key) {
    final raw = box.get(key);
    if (raw is! String) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded.map((item) => item.toString()).toList();
    } catch (_) {
      return [];
    }
  }
}
