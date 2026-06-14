import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/custom_image.dart';
import '../../data/models/food_model.dart';
import '../../data/models/restaurant_model.dart';

const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20);

class FoodieGoScaffold extends StatelessWidget {
  final String title;
  final List<Widget> slivers;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final bool showBack;
  final String fallbackRoute;

  const FoodieGoScaffold({
    super.key,
    required this.title,
    required this.slivers,
    this.actions,
    this.bottomNavigationBar,
    this.showBack = true,
    this.fallbackRoute = AppRoutes.roleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(title),
            leading: showBack
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        context.pop();
                      } else {
                        context.go(fallbackRoute);
                      }
                    },
                  )
                : null,
            actions: actions,
          ),
          ...slivers,
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.headlineSmall)),
          if (actionLabel != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}

class AppSearchBar extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const AppSearchBar({
    super.key,
    this.hint = 'Search restaurants, foods, categories',
    this.onTap,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: screenPadding,
      child: TextField(
        controller: controller,
        onTap: onTap,
        onChanged: onChanged,
        readOnly: onTap != null && onChanged == null,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: const Icon(Icons.tune_rounded),
        ),
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final bool compact;
  final VoidCallback? onTap;
  final Widget? footer;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.compact = false,
    this.onTap,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final width = compact ? 252.0 : double.infinity;
    return SizedBox(
      width: width,
      child: Card(
        child: InkWell(
          onTap:
              onTap ??
              () => context.push(
                '${AppRoutes.restaurantDetailPath}/${restaurant.id}',
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CustomImage(
                    imageUrl: restaurant.image,
                    height: compact ? 132 : 164,
                    width: double.infinity,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: StatusPill(
                      label: restaurant.isOpen ? 'Open' : 'Closed',
                      color: restaurant.isOpen
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: StatusPill(
                      label: '${restaurant.rating.toStringAsFixed(1)} ★',
                      color: AppColors.star,
                      darkText: true,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: AppTextStyles.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      restaurant.categories.join(' • '),
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        MiniMeta(
                          icon: Icons.timer_rounded,
                          text: '${restaurant.deliveryTime} min',
                        ),
                        MiniMeta(
                          icon: Icons.delivery_dining_rounded,
                          text: restaurant.deliveryFee == 0
                              ? 'Free'
                              : 'Rs.${restaurant.deliveryFee.toInt()}',
                        ),
                        MiniMeta(
                          icon: Icons.place_rounded,
                          text: '${restaurant.distance.toStringAsFixed(1)} km',
                        ),
                      ],
                    ),
                    if (footer != null) ...[
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      footer!,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodTile extends StatelessWidget {
  final FoodModel food;
  final VoidCallback? onTap;
  final Widget? trailing;

  const FoodTile({super.key, required this.food, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap:
            onTap ??
            () => context.push('${AppRoutes.foodDetailPath}/${food.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CustomImage(
                imageUrl: food.image,
                width: 82,
                height: 82,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food.restaurantName,
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Rs.${food.price.toInt()}',
                          style: AppTextStyles.priceSmall,
                        ),
                        const SizedBox(width: 10),
                        MiniMeta(
                          icon: Icons.star_rounded,
                          text: food.rating.toStringAsFixed(1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              trailing ?? const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final bool darkText;

  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    this.darkText = false,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: darkText ? AppColors.textPrimary : Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class MiniMeta extends StatelessWidget {
  final IconData icon;
  final String text;

  const MiniMeta({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(text, style: AppTextStyles.caption),
      ],
    );
  }
}

class StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 18),
            Text(value, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.buttonLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor: AppColors.primarySurface,
              child: Icon(icon, color: AppColors.primary, size: 38),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (buttonLabel != null && onPressed != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: 190,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(buttonLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool highlight;

  const PriceRow({
    super.key,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = highlight
        ? AppTextStyles.titleLarge
        : AppTextStyles.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(
            'Rs.${value.toStringAsFixed(0)}',
            style: style.copyWith(
              color: highlight ? AppColors.primary : null,
              fontWeight: highlight ? FontWeight.w700 : null,
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalPaddingSliver extends StatelessWidget {
  final Widget child;

  const HorizontalPaddingSliver({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: screenPadding,
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}

SliverToBoxAdapter gapSliver(double height) {
  return SliverToBoxAdapter(child: SizedBox(height: height));
}

String formatCurrency(num value) => 'Rs.${value.toStringAsFixed(0)}';

Color colorFromHex(String hex) {
  final normalized = hex.replaceAll('#', '');
  return Color(int.parse('FF$normalized', radix: 16));
}
