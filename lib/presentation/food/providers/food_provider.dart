import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/food_model.dart';
import '../../../data/repositories/food_repository.dart';

final foodsProvider = FutureProvider<List<FoodModel>>((ref) {
  return ref.watch(foodRepositoryProvider).getAllFoods();
});

final popularFoodsProvider = FutureProvider<List<FoodModel>>((ref) {
  return ref.watch(foodRepositoryProvider).getPopularFoods();
});

final foodByIdProvider = FutureProvider.family<FoodModel?, String>((ref, id) {
  return ref.watch(foodRepositoryProvider).getFoodById(id);
});

final foodsByRestaurantProvider =
    FutureProvider.family<List<FoodModel>, String>((ref, restaurantId) {
      return ref
          .watch(foodRepositoryProvider)
          .getFoodsByRestaurant(restaurantId);
    });
