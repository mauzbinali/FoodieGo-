import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/review_provider.dart';

class ReviewsScreen extends ConsumerWidget {
  final String restaurantId;

  const ReviewsScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(reviewsByRestaurantProvider(restaurantId));
    return FoodieGoScaffold(
      title: 'Reviews',
      slivers: [
        reviews.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SliverFillRemaining(
            child: EmptyState(
              icon: Icons.reviews_rounded,
              title: 'Reviews unavailable',
              subtitle: 'Please try again later.',
            ),
          ),
          data: (items) => SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final review = items[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person_rounded),
                    ),
                    title: Text(review.userName),
                    subtitle: Text(review.comment),
                    trailing: Text(
                      '${review.rating.toStringAsFixed(1)} ★',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
