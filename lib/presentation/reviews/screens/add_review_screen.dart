import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/review_provider.dart';

class AddReviewScreen extends ConsumerStatefulWidget {
  final String restaurantId;
  final String orderId;

  const AddReviewScreen({
    super.key,
    required this.restaurantId,
    required this.orderId,
  });

  @override
  ConsumerState<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends ConsumerState<AddReviewScreen> {
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewProvider);
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.orders);
            }
          },
        ),
        title: const Text('Write Review'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('How was your experience?'),
          const SizedBox(height: 16),
          RatingBar.builder(
            initialRating: state.rating,
            minRating: 1,
            allowHalfRating: true,
            itemBuilder: (_, __) =>
                const Icon(Icons.star_rounded, color: AppColors.star),
            onRatingUpdate: ref.read(reviewProvider.notifier).setRating,
          ),
          const SizedBox(height: 20),
          AppTextField(
            label: 'Review',
            controller: _comment,
            maxLines: 5,
            onChanged: ref.read(reviewProvider.notifier).setComment,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Image upload is demo-ready.')),
              );
            },
            icon: const Icon(Icons.image_rounded),
            label: const Text('Upload Images'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: state.isLoading
                ? null
                : () async {
                    final ok = await ref
                        .read(reviewProvider.notifier)
                        .submitReview(
                          userId: user?.uid ?? 'demo_user',
                          userName: user?.name ?? 'FoodieGo User',
                          userImage: user?.profileImage,
                          restaurantId: widget.restaurantId,
                          orderId: widget.orderId,
                        );
                    if (ok && context.mounted) context.pop();
                  },
            child: const Text('Submit Review'),
          ),
        ],
      ),
    );
  }
}
