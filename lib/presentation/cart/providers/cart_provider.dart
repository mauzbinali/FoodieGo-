import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/storage/hive_service.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/food_model.dart';

class CartState {
  final List<CartItemModel> items;
  final String? restaurantId;
  final String? restaurantName;
  final String? couponCode;
  final double discount;

  const CartState({
    this.items = const [],
    this.restaurantId,
    this.restaurantName,
    this.couponCode,
    this.discount = 0,
  });

  bool get isEmpty => items.isEmpty;
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * AppConstants.taxRate;
  double get deliveryFee => subtotal >= AppConstants.freeDeliveryThreshold
      ? 0
      : AppConstants.defaultDeliveryFee;
  double get total => subtotal + tax + deliveryFee - discount;

  CartState copyWith({
    List<CartItemModel>? items,
    String? restaurantId,
    String? restaurantName,
    String? couponCode,
    double? discount,
    bool clearCoupon = false,
  }) {
    return CartState(
      items: items ?? this.items,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      couponCode: clearCoupon ? null : couponCode ?? this.couponCode,
      discount: discount ?? this.discount,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final HiveService _hive;
  final Uuid _uuid = const Uuid();

  CartNotifier(this._hive) : super(const CartState()) {
    final items = _hive.getCart().map(CartItemModel.fromMap).toList();
    if (items.isNotEmpty) {
      state = CartState(
        items: items,
        restaurantId: items.first.restaurantId,
        restaurantName: items.first.restaurantName,
      );
    }
  }

  bool canAddFood(FoodModel food) {
    return state.restaurantId == null ||
        state.restaurantId == food.restaurantId;
  }

  void addFood({
    required FoodModel food,
    int quantity = 1,
    List<String> selectedCustomizations = const [],
    double customizationPrice = 0,
  }) {
    final existingIndex = state.items.indexWhere(
      (item) =>
          item.foodId == food.id &&
          _sameList(item.selectedCustomizations, selectedCustomizations),
    );

    final items = [...state.items];
    if (existingIndex >= 0) {
      final current = items[existingIndex];
      items[existingIndex] = current.copyWith(
        quantity: current.quantity + quantity,
      );
    } else {
      items.add(
        CartItemModel.fromFood(
          id: _uuid.v4(),
          food: food,
          quantity: quantity,
          selectedCustomizations: selectedCustomizations,
          customizationPrice: customizationPrice,
        ),
      );
    }

    state = state.copyWith(
      items: items,
      restaurantId: food.restaurantId,
      restaurantName: food.restaurantName,
    );
    _persist();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }
    final items = state.items
        .map(
          (item) =>
              item.id == itemId ? item.copyWith(quantity: quantity) : item,
        )
        .toList();
    state = state.copyWith(items: items);
    _persist();
  }

  void removeItem(String itemId) {
    final items = state.items.where((item) => item.id != itemId).toList();
    state = items.isEmpty
        ? const CartState()
        : state.copyWith(items: items, restaurantId: items.first.restaurantId);
    _persist();
  }

  void applyCoupon(String code, double discount) {
    state = state.copyWith(couponCode: code, discount: discount);
  }

  void clearCoupon() {
    state = state.copyWith(discount: 0, clearCoupon: true);
  }

  void clearCart() {
    state = const CartState();
    _hive.clearCart();
  }

  void _persist() {
    _hive.saveCart(state.items.map((item) => item.toMap()).toList());
  }

  bool _sameList(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref.watch(hiveServiceProvider));
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).totalItems;
});

final cartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).subtotal;
});

final cartIsEmptyProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider).isEmpty;
});
