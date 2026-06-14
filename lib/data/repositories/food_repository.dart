import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/storage/hive_service.dart';
import '../models/food_model.dart';
import 'demo_data.dart';

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepository(
    firestore: Firebase.apps.isEmpty ? null : FirebaseFirestore.instance,
    hive: ref.watch(hiveServiceProvider),
  );
});

class FoodRepository {
  final FirebaseFirestore? _firestore;
  final HiveService _hive;

  FoodRepository({
    required FirebaseFirestore? firestore,
    required HiveService hive,
  }) : _firestore = firestore,
       _hive = hive;

  CollectionReference<Map<String, dynamic>>? get _collection =>
      _firestore?.collection(AppConstants.foodsCollection);

  Future<List<FoodModel>> getAllFoods({bool forceRefresh = false}) async {
    if (_collection == null) return DemoData.foods;
    try {
      if (!forceRefresh) {
        final cached = _hive.getCachedFoods();
        if (cached.isNotEmpty) return cached.map(FoodModel.fromMap).toList();
      }
      final snapshot = await _collection!
          .orderBy('createdAt', descending: true)
          .get();
      final foods = snapshot.docs.map(FoodModel.fromFirestore).toList();
      await _hive.cacheFoods(foods.map((food) => food.toMap()).toList());
      return foods;
    } catch (_) {
      final cached = _hive.getCachedFoods();
      return cached.isNotEmpty
          ? cached.map(FoodModel.fromMap).toList()
          : DemoData.foods;
    }
  }

  Future<FoodModel?> getFoodById(String id) async {
    if (_collection == null) {
      return DemoData.foods.where((f) => f.id == id).firstOrNull;
    }
    final doc = await _collection!.doc(id).get();
    return doc.exists ? FoodModel.fromFirestore(doc) : null;
  }

  Future<List<FoodModel>> getFoodsByRestaurant(String restaurantId) async {
    if (_collection == null) {
      return DemoData.foods
          .where((food) => food.restaurantId == restaurantId)
          .toList();
    }
    final snapshot = await _collection!
        .where('restaurantId', isEqualTo: restaurantId)
        .get();
    return snapshot.docs.map(FoodModel.fromFirestore).toList();
  }

  Future<List<FoodModel>> getPopularFoods() async {
    final all = await getAllFoods();
    return all.where((f) => f.isPopular).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }

  Future<List<FoodModel>> searchFoods(String query) async {
    final lower = query.toLowerCase();
    final all = await getAllFoods();
    return all
        .where(
          (food) =>
              food.name.toLowerCase().contains(lower) ||
              food.restaurantName.toLowerCase().contains(lower) ||
              food.category.toLowerCase().contains(lower),
        )
        .toList();
  }

  Future<FoodModel> createFood(FoodModel food) async {
    if (_collection == null) return food;
    await _collection!.doc(food.id).set(food.toMap());
    return food;
  }

  Future<void> updateFood(FoodModel food) async {
    if (_collection == null) return;
    await _collection!.doc(food.id).update(food.toMap());
  }

  Future<void> updateFoodAvailability(String foodId, bool isAvailable) async {
    if (_collection == null) return;
    await _collection!.doc(foodId).update({'isAvailable': isAvailable});
  }

  Future<void> deleteFood(String foodId) async {
    if (_collection == null) return;
    await _collection!.doc(foodId).delete();
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
