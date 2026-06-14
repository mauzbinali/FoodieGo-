import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/coupon_model.dart';
import '../../../data/models/food_model.dart';
import '../../../data/models/restaurant_model.dart';
import '../../../data/repositories/demo_data.dart';

class DemoManagementState {
  final List<RestaurantModel> restaurants;
  final List<FoodModel> foods;
  final List<CouponModel> coupons;

  const DemoManagementState({
    required this.restaurants,
    required this.foods,
    required this.coupons,
  });

  List<FoodModel> foodsForRestaurant(String restaurantId) {
    return foods.where((food) => food.restaurantId == restaurantId).toList();
  }
}

class DemoManagementNotifier extends StateNotifier<DemoManagementState> {
  DemoManagementNotifier()
    : super(
        DemoManagementState(
          restaurants: List<RestaurantModel>.from(DemoData.restaurants),
          foods: List<FoodModel>.from(DemoData.foods),
          coupons: List<CouponModel>.from(DemoData.coupons),
        ),
      );

  RestaurantModel? restaurantById(String restaurantId) {
    return state.restaurants
        .where((restaurant) => restaurant.id == restaurantId)
        .firstOrNull;
  }

  String uniqueRestaurantId(String name) {
    return _uniqueId(_slug(name), state.restaurants.map((item) => item.id));
  }

  String uniqueFoodId({required String restaurantId, required String name}) {
    return _uniqueId(
      '${restaurantId}_${_slug(name)}',
      state.foods.map((item) => item.id),
    );
  }

  void addRestaurant(RestaurantModel restaurant) {
    DemoData.restaurants.insert(0, restaurant);
    _sync();
  }

  void updateRestaurant(RestaurantModel restaurant) {
    final index = DemoData.restaurants.indexWhere(
      (item) => item.id == restaurant.id,
    );
    if (index == -1) return;
    DemoData.restaurants[index] = restaurant;
    _sync();
  }

  void deleteRestaurant(String restaurantId) {
    DemoData.restaurants.removeWhere((item) => item.id == restaurantId);
    DemoData.foods.removeWhere((item) => item.restaurantId == restaurantId);
    _sync();
  }

  void toggleRestaurantOpen(String restaurantId) {
    final restaurant = restaurantById(restaurantId);
    if (restaurant == null) return;
    updateRestaurant(restaurant.copyWith(isOpen: !restaurant.isOpen));
  }

  void addFood(FoodModel food) {
    DemoData.foods.insert(0, food);
    _sync();
  }

  void updateFood(FoodModel food) {
    final index = DemoData.foods.indexWhere((item) => item.id == food.id);
    if (index == -1) return;
    DemoData.foods[index] = food;
    _sync();
  }

  void deleteFood(String foodId) {
    DemoData.foods.removeWhere((item) => item.id == foodId);
    _sync();
  }

  void toggleFoodAvailability(String foodId) {
    final food = state.foods.where((item) => item.id == foodId).firstOrNull;
    if (food == null) return;
    updateFood(food.copyWith(isAvailable: !food.isAvailable));
  }

  void addCoupon(CouponModel coupon) {
    DemoData.coupons.removeWhere((item) => item.code == coupon.code);
    DemoData.coupons.insert(0, coupon);
    _sync();
  }

  void deleteCoupon(String code) {
    DemoData.coupons.removeWhere((item) => item.code == code);
    _sync();
  }

  void toggleCoupon(String code) {
    final index = DemoData.coupons.indexWhere((item) => item.code == code);
    if (index == -1) return;
    final coupon = DemoData.coupons[index];
    DemoData.coupons[index] = CouponModel(
      code: coupon.code,
      discount: coupon.discount,
      type: coupon.type,
      description: coupon.description,
      maxDiscount: coupon.maxDiscount,
      minOrder: coupon.minOrder,
      isActive: !coupon.isActive,
      expiryDate: coupon.expiryDate,
    );
    _sync();
  }

  void _sync() {
    state = DemoManagementState(
      restaurants: List<RestaurantModel>.from(DemoData.restaurants),
      foods: List<FoodModel>.from(DemoData.foods),
      coupons: List<CouponModel>.from(DemoData.coupons),
    );
  }

  String _uniqueId(String base, Iterable<String> takenIds) {
    final normalized = base.isEmpty ? 'item' : base;
    final taken = takenIds.toSet();
    if (!taken.contains(normalized)) return normalized;
    var index = 2;
    while (taken.contains('${normalized}_$index')) {
      index++;
    }
    return '${normalized}_$index';
  }

  String _slug(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+'), '')
        .replaceAll(RegExp(r'_+$'), '');
  }
}

final demoManagementProvider =
    StateNotifierProvider<DemoManagementNotifier, DemoManagementState>((ref) {
      return DemoManagementNotifier();
    });

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

String imageForCategory(String category) {
  return switch (category) {
    'Pizza' =>
      'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=1000',
    'Healthy' =>
      'https://images.unsplash.com/photo-1628191010210-a59de33e5941?w=1000',
    'Desserts' =>
      'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=1000',
    'Drinks' =>
      'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=1000',
    'BBQ' =>
      'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=1000',
    'Chinese' =>
      'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=1000',
    'Fast Food' =>
      'https://images.unsplash.com/photo-1562967914-608f82629710?w=1000',
    _ => 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=1000',
  };
}

List<String> defaultFoodCategories() => AppConstants.foodCategories;
