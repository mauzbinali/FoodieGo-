import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_helpers.dart';

class RestaurantModel {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String image;
  final String logo;
  final List<String> categories;
  final double rating;
  final int reviewCount;
  final int deliveryTime;
  final double deliveryFee;
  final double distance;
  final double latitude;
  final double longitude;
  final String address;
  final bool isOpen;
  final bool isFeatured;
  final bool isPopular;
  final DateTime createdAt;

  const RestaurantModel({
    required this.id,
    this.ownerId = '',
    required this.name,
    required this.description,
    required this.image,
    required this.logo,
    required this.categories,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.isOpen = true,
    this.isFeatured = false,
    this.isPopular = false,
    required this.createdAt,
  });

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      id: (map['id'] ?? '').toString(),
      ownerId: (map['ownerId'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      image: (map['image'] ?? map['imageUrl'] ?? '').toString(),
      logo: (map['logo'] ?? map['logoUrl'] ?? '').toString(),
      categories: stringListFromValue(map['categories']),
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      deliveryTime: (map['deliveryTime'] as num?)?.toInt() ?? 30,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0,
      distance: (map['distance'] as num?)?.toDouble() ?? 0,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      address: (map['address'] ?? '').toString(),
      isOpen: map['isOpen'] as bool? ?? true,
      isFeatured: map['isFeatured'] as bool? ?? false,
      isPopular: map['isPopular'] as bool? ?? false,
      createdAt: dateTimeFromValue(map['createdAt']),
    );
  }

  factory RestaurantModel.fromFirestore(DocumentSnapshot doc) {
    return RestaurantModel.fromMap({...mapFromValue(doc.data()), 'id': doc.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'image': image,
      'logo': logo,
      'categories': categories,
      'rating': rating,
      'reviewCount': reviewCount,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
      'distance': distance,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'isOpen': isOpen,
      'isFeatured': isFeatured,
      'isPopular': isPopular,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  RestaurantModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    String? image,
    String? logo,
    List<String>? categories,
    double? rating,
    int? reviewCount,
    int? deliveryTime,
    double? deliveryFee,
    double? distance,
    double? latitude,
    double? longitude,
    String? address,
    bool? isOpen,
    bool? isFeatured,
    bool? isPopular,
    DateTime? createdAt,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      logo: logo ?? this.logo,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      distance: distance ?? this.distance,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      isOpen: isOpen ?? this.isOpen,
      isFeatured: isFeatured ?? this.isFeatured,
      isPopular: isPopular ?? this.isPopular,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
