import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../admin/providers/demo_management_provider.dart';
import '../../shared/foodiego_ui.dart';

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foods = ref.watch(
      demoManagementProvider.select(
        (state) => state.foodsForRestaurant('mcdonalds'),
      ),
    );

    return FoodieGoScaffold(
      title: 'Owner Dashboard',
      fallbackRoute: AppRoutes.roleSelection,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.08,
            children: const [
              StatTile(
                label: 'Revenue',
                value: 'Rs.86k',
                icon: Icons.payments_rounded,
              ),
              StatTile(
                label: 'Orders',
                value: '128',
                icon: Icons.receipt_long_rounded,
                color: AppColors.secondary,
              ),
              StatTile(
                label: 'Customers',
                value: '92',
                icon: Icons.groups_rounded,
                color: AppColors.info,
              ),
              StatTile(
                label: 'Rating',
                value: '4.7',
                icon: Icons.star_rounded,
                color: AppColors.star,
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: SectionHeader(title: 'Top Selling Foods'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList.separated(
            itemCount: foods.take(5).length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => FoodTile(food: foods[index]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.ownerMenuManagement),
                icon: const Icon(Icons.restaurant_menu_rounded),
                label: const Text('Manage Menu'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.ownerOrders),
                icon: const Icon(Icons.receipt_long_rounded),
                label: const Text('Manage Orders'),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
