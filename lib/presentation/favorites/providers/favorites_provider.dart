import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/hive_service.dart';
import '../../../data/models/food_model.dart';
import '../../../data/models/restaurant_model.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../data/repositories/restaurant_repository.dart';

class FavoritesState {
  final List<String> restaurantIds;
  final List<String> foodIds;

  const FavoritesState({
    this.restaurantIds = const [],
    this.foodIds = const [],
  });
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final HiveService _hive;

  FavoritesNotifier(this._hive) : super(const FavoritesState()) {
    state = FavoritesState(
      restaurantIds: _hive.getFavoriteRestaurantIds(),
      foodIds: _hive.getFavoriteFoodIds(),
    );
  }

  Future<void> toggleFavoriteRestaurant(String id) async {
    if (state.restaurantIds.contains(id)) {
      await _hive.removeFavoriteRestaurant(id);
    } else {
      await _hive.addFavoriteRestaurant(id);
    }
    state = FavoritesState(
      restaurantIds: _hive.getFavoriteRestaurantIds(),
      foodIds: state.foodIds,
    );
  }

  Future<void> toggleFavoriteFood(String id) async {
    if (state.foodIds.contains(id)) {
      await _hive.removeFavoriteFood(id);
    } else {
      await _hive.addFavoriteFood(id);
    }
    state = FavoritesState(
      restaurantIds: state.restaurantIds,
      foodIds: _hive.getFavoriteFoodIds(),
    );
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
      return FavoritesNotifier(ref.watch(hiveServiceProvider));
    });

final isFavoriteRestaurantProvider = Provider.family<bool, String>((ref, id) {
  return ref.watch(favoritesProvider).restaurantIds.contains(id);
});

final isFavoriteFoodProvider = Provider.family<bool, String>((ref, id) {
  return ref.watch(favoritesProvider).foodIds.contains(id);
});

final favoriteRestaurantsProvider = FutureProvider<List<RestaurantModel>>((
  ref,
) async {
  final ids = ref.watch(favoritesProvider).restaurantIds;
  final all = await ref.watch(restaurantRepositoryProvider).getAllRestaurants();
  return all.where((restaurant) => ids.contains(restaurant.id)).toList();
});

final favoriteFoodsProvider = FutureProvider<List<FoodModel>>((ref) async {
  final ids = ref.watch(favoritesProvider).foodIds;
  final all = await ref.watch(foodRepositoryProvider).getAllFoods();
  return all.where((food) => ids.contains(food.id)).toList();
});
