import 'food_model.dart';
import 'model_helpers.dart';

class CartItemModel {
  final String id;
  final String foodId;
  final String restaurantId;
  final String restaurantName;
  final String name;
  final String image;
  final double basePrice;
  final int quantity;
  final List<String> selectedCustomizations;
  final double customizationPrice;

  const CartItemModel({
    required this.id,
    required this.foodId,
    required this.restaurantId,
    required this.restaurantName,
    required this.name,
    required this.image,
    required this.basePrice,
    required this.quantity,
    this.selectedCustomizations = const [],
    this.customizationPrice = 0,
  });

  factory CartItemModel.fromFood({
    required String id,
    required FoodModel food,
    int quantity = 1,
    List<String> selectedCustomizations = const [],
    double customizationPrice = 0,
  }) {
    return CartItemModel(
      id: id,
      foodId: food.id,
      restaurantId: food.restaurantId,
      restaurantName: food.restaurantName,
      name: food.name,
      image: food.image,
      basePrice: food.price,
      quantity: quantity,
      selectedCustomizations: selectedCustomizations,
      customizationPrice: customizationPrice,
    );
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: (map['id'] ?? '').toString(),
      foodId: (map['foodId'] ?? '').toString(),
      restaurantId: (map['restaurantId'] ?? '').toString(),
      restaurantName: (map['restaurantName'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
      basePrice: (map['basePrice'] as num?)?.toDouble() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      selectedCustomizations: stringListFromValue(
        map['selectedCustomizations'],
      ),
      customizationPrice: (map['customizationPrice'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodId': foodId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'name': name,
      'image': image,
      'basePrice': basePrice,
      'quantity': quantity,
      'selectedCustomizations': selectedCustomizations,
      'customizationPrice': customizationPrice,
    };
  }

  double get unitPrice => basePrice + customizationPrice;
  double get totalPrice => unitPrice * quantity;

  CartItemModel copyWith({
    String? id,
    String? foodId,
    String? restaurantId,
    String? restaurantName,
    String? name,
    String? image,
    double? basePrice,
    int? quantity,
    List<String>? selectedCustomizations,
    double? customizationPrice,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      name: name ?? this.name,
      image: image ?? this.image,
      basePrice: basePrice ?? this.basePrice,
      quantity: quantity ?? this.quantity,
      selectedCustomizations:
          selectedCustomizations ?? this.selectedCustomizations,
      customizationPrice: customizationPrice ?? this.customizationPrice,
    );
  }
}
