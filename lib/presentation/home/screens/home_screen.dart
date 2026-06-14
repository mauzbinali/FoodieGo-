import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/restaurant_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../notifications/providers/notification_provider.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/restaurant_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final featured = ref.watch(featuredRestaurantsProvider);
    final popular = ref.watch(popularRestaurantsProvider);
    final topRated = ref.watch(topRatedRestaurantsProvider);
    final notifications = ref.watch(unreadNotificationCountProvider);
    final banners = ref.watch(bannersProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text('Deliver to', style: AppTextStyles.caption),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Gulberg, Lahore',
                            style: AppTextStyles.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton.filledTonal(
                          onPressed: () =>
                              context.push(AppRoutes.notifications),
                          icon: const Icon(Icons.notifications_none_rounded),
                        ),
                        Positioned(
                          right: 9,
                          top: 9,
                          child: notifications.maybeWhen(
                            data: (count) => count > 0
                                ? const CircleAvatar(
                                    radius: 5,
                                    backgroundColor: AppColors.error,
                                  )
                                : const SizedBox.shrink(),
                            orElse: SizedBox.shrink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        (user?.name.isNotEmpty ?? false)
                            ? user!.name.characters.first.toUpperCase()
                            : 'F',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Text(
                  'What would you like to eat today?',
                  style: AppTextStyles.displaySmall,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: AppSearchBar(onTap: () => context.push(AppRoutes.search)),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 170,
                child: PageView.builder(
                  padEnds: false,
                  controller: PageController(viewportFraction: 0.88),
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    final color = colorFromHex(banner.colorHex);
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 20 : 8,
                        right: 8,
                        top: 14,
                        bottom: 8,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      banner.title,
                                      style: AppTextStyles.headlineMedium
                                          .copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      banner.subtitle,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.84,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.local_offer_rounded,
                                color: Colors.white,
                                size: 48,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SectionHeader(title: 'Categories')),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 106,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConstants.foodCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final category = AppConstants.foodCategories[index];
                    return InkWell(
                      onTap: () => context.push(
                        '${AppRoutes.restaurantList}?category=$category&title=$category',
                      ),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 86,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _categoryIcon(category),
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              category,
                              style: AppTextStyles.labelMedium,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            _restaurantSection(
              context,
              title: 'Featured Restaurants',
              restaurants: featured,
            ),
            _restaurantSection(
              context,
              title: 'Popular Restaurants',
              restaurants: popular,
            ),
            _restaurantSection(
              context,
              title: 'Top Rated Restaurants',
              restaurants: topRated,
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _restaurantSection(
    BuildContext context, {
    required String title,
    required AsyncValue<List<RestaurantModel>> restaurants,
  }) {
    return SliverToBoxAdapter(
      child: restaurants.when(
        loading: () => const SizedBox(
          height: 260,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const SizedBox.shrink(),
        data: (items) => Column(
          children: [
            SectionHeader(
              title: title,
              actionLabel: 'See all',
              onAction: () => context.push(AppRoutes.restaurantList),
            ),
            SizedBox(
              height: 270,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) =>
                    RestaurantCard(restaurant: items[index], compact: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    return switch (category) {
      'Burgers' => Icons.lunch_dining_rounded,
      'Pizza' => Icons.local_pizza_rounded,
      'BBQ' => Icons.outdoor_grill_rounded,
      'Chinese' => Icons.ramen_dining_rounded,
      'Desserts' => Icons.icecream_rounded,
      'Drinks' => Icons.local_cafe_rounded,
      'Healthy' => Icons.eco_rounded,
      _ => Icons.fastfood_rounded,
    };
  }
}
