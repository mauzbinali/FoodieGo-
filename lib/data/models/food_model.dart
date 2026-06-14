import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_helpers.dart';

class FoodModel {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String name;
  final String description;
  final String image;
  final String category;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviewCount;
  final int preparationTime;
  final bool isAvailable;
  final bool isPopular;
  final List<String> customizations;
  final DateTime createdAt;

  const FoodModel({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.price,
    this.oldPrice = 0,
    this.rating = 0,
    this.reviewCount = 0,
    this.preparationTime = 15,
    this.isAvailable = true,
    this.isPopular = false,
    this.customizations = const [],
    required this.createdAt,
  });

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      id: (map['id'] ?? '').toString(),
      restaurantId: (map['restaurantId'] ?? '').toString(),
      restaurantName: (map['restaurantName'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      image: (map['image'] ?? map['imageUrl'] ?? '').toString(),
      category: (map['category'] ?? '').toString(),
      price: (map['price'] as num?)?.toDouble() ?? 0,
      oldPrice: (map['oldPrice'] as num?)?.toDouble() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      preparationTime: (map['preparationTime'] as num?)?.toInt() ?? 15,
      isAvailable: map['isAvailable'] as bool? ?? true,
      isPopular: map['isPopular'] as bool? ?? false,
      customizations: stringListFromValue(map['customizations']),
      createdAt: dateTimeFromValue(map['createdAt']),
    );
  }

  factory FoodModel.fromFirestore(DocumentSnapshot doc) {
    return FoodModel.fromMap({...mapFromValue(doc.data()), 'id': doc.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'name': name,
      'description': description,
      'image': image,
      'category': category,
      'price': price,
      'oldPrice': oldPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'preparationTime': preparationTime,
      'isAvailable': isAvailable,
      'isPopular': isPopular,
      'customizations': customizations,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  FoodModel copyWith({
    String? id,
    String? restaurantId,
    String? restaurantName,
    String? name,
    String? description,
    String? image,
    String? category,
    double? price,
    double? oldPrice,
    double? rating,
    int? reviewCount,
    int? preparationTime,
    bool? isAvailable,
    bool? isPopular,
    List<String>? customizations,
    DateTime? createdAt,
  }) {
    return FoodModel(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      category: category ?? this.category,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      preparationTime: preparationTime ?? this.preparationTime,
      isAvailable: isAvailable ?? this.isAvailable,
      isPopular: isPopular ?? this.isPopular,
      customizations: customizations ?? this.customizations,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
