import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../admin/providers/demo_management_provider.dart';
import '../../shared/foodiego_ui.dart';

class OwnerMenuScreen extends ConsumerWidget {
  const OwnerMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foods = ref.watch(
      demoManagementProvider.select(
        (state) => state.foodsForRestaurant('mcdonalds'),
      ),
    );
    final notifier = ref.read(demoManagementProvider.notifier);

    return FoodieGoScaffold(
      title: 'Menu Management',
      fallbackRoute: AppRoutes.ownerDashboard,
      actions: [
        IconButton(
          tooltip: 'Add Food',
          onPressed: () => context.push(AppRoutes.ownerAddFood),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
      slivers: [
        if (foods.isEmpty)
          SliverFillRemaining(
            child: EmptyState(
              icon: Icons.restaurant_menu_rounded,
              title: 'No menu items yet',
              subtitle: 'Add your first food item for this restaurant.',
              buttonLabel: 'Add Food',
              onPressed: () => context.push(AppRoutes.ownerAddFood),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList.separated(
              itemCount: foods.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final food = foods[index];
                return FoodTile(
                  food: food,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        context.push(
                          '${AppRoutes.ownerEditFoodPath}/${food.id}',
                        );
                      }
                      if (value == 'availability') {
                        notifier.toggleFoodAvailability(food.id);
                      }
                      if (value == 'delete') {
                        notifier.deleteFood(food.id);
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(
                        value: 'availability',
                        child: Text(
                          food.isAvailable
                              ? 'Mark unavailable'
                              : 'Mark available',
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
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
