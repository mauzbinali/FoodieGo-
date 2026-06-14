import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class RatingBarWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final bool showCount;
  final double itemSize;
  final bool isReadOnly;
  final ValueChanged<double>? onRatingUpdate;

  const RatingBarWidget({
    super.key,
    required this.rating,
    this.reviewCount = 0,
    this.showCount = true,
    this.itemSize = 16,
    this.isReadOnly = true,
    this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: itemSize,
          ignoreGestures: isReadOnly,
          itemBuilder: (context, _) =>
              const Icon(Icons.star_rounded, color: AppColors.star),
          unratedColor: AppColors.border,
          onRatingUpdate: onRatingUpdate ?? (_) {},
        ),
        if (showCount && reviewCount > 0) ...[
          const SizedBox(width: 6),
          Text('($reviewCount)', style: AppTextStyles.caption),
        ],
      ],
    );
  }
}

class RatingChip extends StatelessWidget {
  final double rating;
  final bool small;

  const RatingChip({super.key, required this.rating, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.star.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: AppColors.star,
            size: small ? 12 : 14,
          ),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: small
                ? AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  )
                : AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
          ),
        ],
      ),
    );
  }
}
