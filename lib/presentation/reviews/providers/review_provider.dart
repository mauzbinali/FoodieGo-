import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/review_model.dart';
import '../../../data/repositories/review_repository.dart';

final reviewsByRestaurantProvider =
    StreamProvider.family<List<ReviewModel>, String>((ref, restaurantId) {
      return ref
          .watch(reviewRepositoryProvider)
          .getReviewsByRestaurantStream(restaurantId);
    });

final reviewsByRestaurantFutureProvider =
    FutureProvider.family<List<ReviewModel>, String>((ref, restaurantId) {
      return ref
          .watch(reviewRepositoryProvider)
          .getReviewsByRestaurant(restaurantId);
    });

class ReviewSubmissionState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final double rating;
  final String comment;
  final List<String> imageUrls;

  const ReviewSubmissionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.rating = 5,
    this.comment = '',
    this.imageUrls = const [],
  });

  ReviewSubmissionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    double? rating,
    String? comment,
    List<String>? imageUrls,
  }) {
    return ReviewSubmissionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}

class ReviewNotifier extends StateNotifier<ReviewSubmissionState> {
  final ReviewRepository _repo;

  ReviewNotifier(this._repo) : super(const ReviewSubmissionState());

  void setRating(double rating) => state = state.copyWith(rating: rating);
  void setComment(String comment) => state = state.copyWith(comment: comment);

  Future<bool> submitReview({
    required String userId,
    required String userName,
    String? userImage,
    required String restaurantId,
    String? foodId,
    String? orderId,
  }) async {
    if (state.comment.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please write a review comment.');
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    await _repo.addReview(
      userId: userId,
      userName: userName,
      userImage: userImage,
      restaurantId: restaurantId,
      foodId: foodId,
      orderId: orderId,
      rating: state.rating,
      comment: state.comment,
      images: state.imageUrls,
    );
    state = state.copyWith(isLoading: false, isSuccess: true);
    return true;
  }

  void reset() => state = const ReviewSubmissionState();
}

final reviewProvider =
    StateNotifierProvider.autoDispose<ReviewNotifier, ReviewSubmissionState>(
      (ref) => ReviewNotifier(ref.watch(reviewRepositoryProvider)),
    );
