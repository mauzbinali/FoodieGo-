import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_image.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../../food/providers/food_provider.dart';
import '../../reviews/providers/review_provider.dart';
import '../../shared/foodiego_ui.dart';
import '../../home/providers/restaurant_provider.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String restaurantId;

  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantAsync = ref.watch(restaurantByIdProvider(restaurantId));
    final foodsAsync = ref.watch(foodsByRestaurantProvider(restaurantId));
    final reviewsAsync = ref.watch(reviewsByRestaurantProvider(restaurantId));
    final isFavorite = ref.watch(isFavoriteRestaurantProvider(restaurantId));

    return restaurantAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(
        body: EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Restaurant unavailable',
          subtitle: 'Please try again in a moment.',
        ),
      ),
      data: (restaurant) {
        if (restaurant == null) {
          return const Scaffold(
            body: EmptyState(
              icon: Icons.restaurant_rounded,
              title: 'Restaurant not found',
              subtitle: 'This restaurant is not available anymore.',
            ),
          );
        }

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, _) => [
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  leading: IconButton.filledTonal(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
                  ),
                  actions: [
                    IconButton.filledTonal(
                      onPressed: () => ref
                          .read(favoritesProvider.notifier)
                          .toggleFavoriteRestaurant(restaurant.id),
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CustomImage(imageUrl: restaurant.image),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppColors.cardGradient,
                          ),
                        ),
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StatusPill(
                                label: restaurant.isOpen
                                    ? 'Open now'
                                    : 'Closed',
                                color: restaurant.isOpen
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                restaurant.name,
                                style: AppTextStyles.displaySmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  MiniMeta(
                                    icon: Icons.star_rounded,
                                    text:
                                        '${restaurant.rating.toStringAsFixed(1)} (${restaurant.reviewCount})',
                                  ),
                                  MiniMeta(
                                    icon: Icons.timer_rounded,
                                    text: '${restaurant.deliveryTime} min',
                                  ),
                                  MiniMeta(
                                    icon: Icons.delivery_dining_rounded,
                                    text:
                                        'Rs.${restaurant.deliveryFee.toInt()}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottom: const TabBar(
                    tabs: [
                      Tab(text: 'Menu'),
                      Tab(text: 'Reviews'),
                      Tab(text: 'Info'),
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                children: [
                  foodsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const EmptyState(
                      icon: Icons.fastfood_rounded,
                      title: 'Menu unavailable',
                      subtitle: 'Please try again later.',
                    ),
                    data: (foods) => ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: foods.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          FoodTile(food: foods[index]),
                    ),
                  ),
                  reviewsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (reviews) => ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => context.push(
                            '${AppRoutes.addReview}?restaurantId=${restaurant.id}',
                          ),
                          icon: const Icon(Icons.rate_review_rounded),
                          label: const Text('Write a Review'),
                        ),
                        const SizedBox(height: 16),
                        if (reviews.isEmpty)
                          const EmptyState(
                            icon: Icons.reviews_rounded,
                            title: 'No reviews yet',
                            subtitle: 'Be the first to share your experience.',
                          )
                        else
                          ...reviews.map(
                            (review) => Card(
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
                            ),
                          ),
                      ],
                    ),
                  ),
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(restaurant.description),
                      const SizedBox(height: 16),
                      _InfoRow(
                        icon: Icons.place_rounded,
                        title: 'Address',
                        value: restaurant.address,
                      ),
                      _InfoRow(
                        icon: Icons.shopping_bag_rounded,
                        title: 'Minimum order',
                        value: 'Rs.500',
                      ),
                      _InfoRow(
                        icon: Icons.category_rounded,
                        title: 'Categories',
                        value: restaurant.categories.join(', '),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
