import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final ShapeDecoration? decoration;

  const ShimmerWidget.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  }) : decoration = null;

  const ShimmerWidget.circular({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = size / 2,
      decoration = null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark
          ? AppColors.surfaceVariantDark
          : const Color(0xFFE8E8E8),
      highlightColor: isDark
          ? AppColors.borderDarkMode
          : const Color(0xFFF5F5F5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceVariantDark : Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class RestaurantCardShimmer extends StatelessWidget {
  const RestaurantCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.rectangular(
            width: double.infinity,
            height: 160,
            borderRadius: 16,
          ),
          const SizedBox(height: 12),
          ShimmerWidget.rectangular(width: 200, height: 16),
          const SizedBox(height: 8),
          ShimmerWidget.rectangular(width: 140, height: 12),
          const SizedBox(height: 8),
          Row(
            children: [
              ShimmerWidget.rectangular(width: 80, height: 12),
              const SizedBox(width: 12),
              ShimmerWidget.rectangular(width: 80, height: 12),
              const SizedBox(width: 12),
              ShimmerWidget.rectangular(width: 80, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}

class FoodCardShimmer extends StatelessWidget {
  const FoodCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ShimmerWidget.rectangular(width: 90, height: 90, borderRadius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget.rectangular(width: 160, height: 14),
                const SizedBox(height: 8),
                ShimmerWidget.rectangular(width: 120, height: 12),
                const SizedBox(height: 8),
                ShimmerWidget.rectangular(width: 80, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeSectionShimmer extends StatelessWidget {
  const HomeSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget.rectangular(width: 140, height: 18),
              ShimmerWidget.rectangular(width: 60, height: 14),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, __) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget.rectangular(
                  width: 200,
                  height: 140,
                  borderRadius: 16,
                ),
                const SizedBox(height: 10),
                ShimmerWidget.rectangular(width: 160, height: 14),
                const SizedBox(height: 6),
                ShimmerWidget.rectangular(width: 120, height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
