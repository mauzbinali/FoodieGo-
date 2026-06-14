import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/admin_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(adminStatsProvider);
    return FoodieGoScaffold(
      title: 'Admin Dashboard',
      slivers: [
        stats.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SliverFillRemaining(
            child: EmptyState(
              icon: Icons.analytics_rounded,
              title: 'Analytics unavailable',
              subtitle: 'Please try again later.',
            ),
          ),
          data: (value) => SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.06,
              children: [
                StatTile(
                  label: 'Users',
                  value: '${value.totalUsers}',
                  icon: Icons.people_rounded,
                ),
                StatTile(
                  label: 'Restaurants',
                  value: '${value.totalRestaurants}',
                  icon: Icons.storefront_rounded,
                  color: AppColors.secondary,
                ),
                StatTile(
                  label: 'Orders',
                  value: '${value.totalOrders}',
                  icon: Icons.receipt_long_rounded,
                  color: AppColors.info,
                ),
                StatTile(
                  label: 'Revenue',
                  value: formatCurrency(value.totalRevenue),
                  icon: Icons.payments_rounded,
                  color: AppColors.success,
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _AdminTile(
                icon: Icons.people_rounded,
                title: 'Manage Users',
                onTap: () => context.push(AppRoutes.adminUsers),
              ),
              _AdminTile(
                icon: Icons.storefront_rounded,
                title: 'Manage Restaurants',
                onTap: () => context.push(AppRoutes.adminRestaurants),
              ),
              _AdminTile(
                icon: Icons.fastfood_rounded,
                title: 'Manage Foods',
                onTap: () => context.push(AppRoutes.adminFoods),
              ),
              _AdminTile(
                icon: Icons.receipt_long_rounded,
                title: 'Manage Orders',
                onTap: () => context.push(AppRoutes.adminOrders),
              ),
              _AdminTile(
                icon: Icons.local_offer_rounded,
                title: 'Manage Coupons',
                onTap: () => context.push(AppRoutes.adminCoupons),
              ),
              _AdminTile(
                icon: Icons.notifications_rounded,
                title: 'Send Notifications',
                onTap: () => context.push(AppRoutes.adminNotifications),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _AdminTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AdminTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
