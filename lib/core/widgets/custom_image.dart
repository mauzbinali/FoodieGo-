import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class CustomImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;

  const CustomImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder(isDark);
    }

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _buildShimmer(isDark),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildPlaceholder(isDark),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  Widget _buildShimmer(bool isDark) {
    return Shimmer.fromColors(
      baseColor:
          shimmerBaseColor ??
          (isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant),
      highlightColor:
          shimmerHighlightColor ??
          (isDark ? AppColors.borderDarkMode : AppColors.border),
      child: Container(
        width: width,
        height: height,
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant,
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      width: width,
      height: height,
      color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant,
      child: const Icon(Icons.restaurant, color: AppColors.textHint, size: 40),
    );
  }
}
