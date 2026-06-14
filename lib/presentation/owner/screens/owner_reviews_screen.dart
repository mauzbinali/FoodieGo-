import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/demo_data.dart';
import '../../shared/foodiego_ui.dart';

class OwnerReviewsScreen extends StatelessWidget {
  const OwnerReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FoodieGoScaffold(
      title: 'Review Management',
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList.separated(
            itemCount: DemoData.reviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final review = DemoData.reviews[index];
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
      ],
    );
  }
}
