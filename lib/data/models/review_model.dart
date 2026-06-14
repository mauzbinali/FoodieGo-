import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_helpers.dart';

class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String? userImage;
  final String restaurantId;
  final String? foodId;
  final String? orderId;
  final double rating;
  final String comment;
  final List<String> images;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.restaurantId,
    this.foodId,
    this.orderId,
    required this.rating,
    required this.comment,
    this.images = const [],
    required this.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: (map['id'] ?? '').toString(),
      userId: (map['userId'] ?? '').toString(),
      userName: (map['userName'] ?? 'Anonymous').toString(),
      userImage: map['userImage']?.toString(),
      restaurantId: (map['restaurantId'] ?? '').toString(),
      foodId: map['foodId']?.toString(),
      orderId: map['orderId']?.toString(),
      rating: (map['rating'] as num?)?.toDouble() ?? 5,
      comment: (map['comment'] ?? '').toString(),
      images: stringListFromValue(map['images']),
      createdAt: dateTimeFromValue(map['createdAt']),
    );
  }

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    return ReviewModel.fromMap({...mapFromValue(doc.data()), 'id': doc.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'restaurantId': restaurantId,
      'foodId': foodId,
      'orderId': orderId,
      'rating': rating,
      'comment': comment,
      'images': images,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
