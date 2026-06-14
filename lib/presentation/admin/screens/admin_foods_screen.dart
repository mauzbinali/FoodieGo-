import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/demo_management_provider.dart';

class AdminFoodsScreen extends ConsumerWidget {
  const AdminFoodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foods = ref.watch(demoManagementProvider).foods;
    final notifier = ref.read(demoManagementProvider.notifier);

    return FoodieGoScaffold(
      title: 'Foods',
      fallbackRoute: AppRoutes.adminDashboard,
      actions: [
        IconButton(
          tooltip: 'Add Food',
          onPressed: () => context.push(AppRoutes.adminAddFood),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
      slivers: [
        if (foods.isEmpty)
          SliverFillRemaining(
            child: EmptyState(
              icon: Icons.fastfood_rounded,
              title: 'No foods yet',
              subtitle: 'Add menu items for any restaurant.',
              buttonLabel: 'Add Food',
              onPressed: () => context.push(AppRoutes.adminAddFood),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList.separated(
              itemCount: foods.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final food = foods[index];
                return FoodTile(
                  food: food,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'availability') {
                        notifier.toggleFoodAvailability(food.id);
                      }
                      if (value == 'delete') {
                        notifier.deleteFood(food.id);
                      }
                    },
                    itemBuilder: (_) => [
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
