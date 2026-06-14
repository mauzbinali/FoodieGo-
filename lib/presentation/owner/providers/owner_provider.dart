import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/food_model.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../data/repositories/order_repository.dart';
import '../../auth/providers/auth_provider.dart';
import '../../home/providers/restaurant_provider.dart';

class OwnerStats {
  final double totalRevenue;
  final int totalOrders;
  final int totalCustomers;
  final List<FoodModel> topFoods;

  const OwnerStats({
    this.totalRevenue = 0,
    this.totalOrders = 0,
    this.totalCustomers = 0,
    this.topFoods = const [],
  });
}

final ownerStatsProvider = FutureProvider<OwnerStats>((ref) async {
  final user = ref.watch(authProvider).user;
  if (user == null || !user.isOwner) return const OwnerStats();

  final restaurant = await ref.watch(ownerRestaurantProvider(user.uid).future);
  if (restaurant == null) return const OwnerStats();

  final orders = await ref
      .watch(orderRepositoryProvider)
      .getRestaurantOrders(restaurant.id);
  final foods = await ref
      .watch(foodRepositoryProvider)
      .getFoodsByRestaurant(restaurant.id);
  final revenue = orders
      .where((order) => order.isDelivered)
      .fold(0.0, (sum, order) => sum + order.totalPrice);
  final customers = orders.map((order) => order.userId).toSet().length;

  return OwnerStats(
    totalRevenue: revenue,
    totalOrders: orders.length,
    totalCustomers: customers,
    topFoods: foods.take(5).toList(),
  );
});

class OwnerFoodNotifier extends StateNotifier<AsyncValue<List<FoodModel>>> {
  final FoodRepository _foodRepo;
  final String _restaurantId;

  OwnerFoodNotifier({
    required FoodRepository foodRepo,
    required String restaurantId,
  }) : _foodRepo = foodRepo,
       _restaurantId = restaurantId,
       super(const AsyncValue.loading()) {
    loadFoods();
  }

  Future<void> loadFoods() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(
        await _foodRepo.getFoodsByRestaurant(_restaurantId),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> addFood(FoodModel food) async {
    await _foodRepo.createFood(food);
    await loadFoods();
    return true;
  }

  Future<bool> updateFood(FoodModel food) async {
    await _foodRepo.updateFood(food);
    await loadFoods();
    return true;
  }

  Future<bool> deleteFood(String foodId) async {
    await _foodRepo.deleteFood(foodId);
    await loadFoods();
    return true;
  }
}

final ownerFoodProvider =
    StateNotifierProvider<OwnerFoodNotifier, AsyncValue<List<FoodModel>>>((
      ref,
    ) {
      final user = ref.watch(authProvider).user;
      return OwnerFoodNotifier(
        foodRepo: ref.watch(foodRepositoryProvider),
        restaurantId: user?.restaurantId ?? '',
      );
    });
