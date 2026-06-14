import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/review_model.dart';
import 'demo_data.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository();
});

class ReviewRepository {
  static final List<ReviewModel> _reviews = [...DemoData.reviews];
  final Uuid _uuid = const Uuid();

  Future<List<ReviewModel>> getReviewsByRestaurant(String restaurantId) async {
    return _reviews
        .where((review) => review.restaurantId == restaurantId)
        .toList();
  }

  Stream<List<ReviewModel>> getReviewsByRestaurantStream(String restaurantId) {
    return Stream.value(
      _reviews.where((review) => review.restaurantId == restaurantId).toList(),
    );
  }

  Future<ReviewModel> addReview({
    required String userId,
    required String userName,
    String? userImage,
    required String restaurantId,
    String? foodId,
    String? orderId,
    required double rating,
    required String comment,
    List<String> images = const [],
  }) async {
    final review = ReviewModel(
      id: _uuid.v4(),
      userId: userId,
      userName: userName,
      userImage: userImage,
      restaurantId: restaurantId,
      foodId: foodId,
      orderId: orderId,
      rating: rating,
      comment: comment,
      images: images,
      createdAt: DateTime.now(),
    );
    _reviews.insert(0, review);
    return review;
  }
}
