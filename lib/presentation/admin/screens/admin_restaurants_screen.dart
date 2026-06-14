import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/demo_management_provider.dart';

class AdminRestaurantsScreen extends ConsumerWidget {
  const AdminRestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurants = ref.watch(demoManagementProvider).restaurants;
    final notifier = ref.read(demoManagementProvider.notifier);

    return FoodieGoScaffold(
      title: 'Restaurants',
      fallbackRoute: AppRoutes.adminDashboard,
      actions: [
        IconButton(
          tooltip: 'Add Restaurant',
          onPressed: () => context.push(AppRoutes.adminAddRestaurant),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
      slivers: [
        if (restaurants.isEmpty)
          SliverFillRemaining(
            child: EmptyState(
              icon: Icons.storefront_rounded,
              title: 'No restaurants yet',
              subtitle: 'Add a restaurant to start building the marketplace.',
              buttonLabel: 'Add Restaurant',
              onPressed: () => context.push(AppRoutes.adminAddRestaurant),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList.separated(
              itemCount: restaurants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return RestaurantCard(
                  restaurant: restaurant,
                  footer: Row(
                    children: [
                      StatusPill(
                        label: restaurant.isOpen ? 'Open' : 'Closed',
                        color: restaurant.isOpen
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () =>
                            notifier.toggleRestaurantOpen(restaurant.id),
                        icon: Icon(
                          restaurant.isOpen
                              ? Icons.pause_circle_outline_rounded
                              : Icons.play_circle_outline_rounded,
                        ),
                        label: Text(restaurant.isOpen ? 'Pause' : 'Open'),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        onPressed: () =>
                            notifier.deleteRestaurant(restaurant.id),
                        icon: const Icon(Icons.delete_outline_rounded),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
