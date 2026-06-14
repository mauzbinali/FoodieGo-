import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      (user?.name.isNotEmpty ?? false)
                          ? user!.name.characters.first.toUpperCase()
                          : 'F',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'FoodieGo User',
                          style: AppTextStyles.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(user?.email ?? 'demo@foodiego.com'),
                        const SizedBox(height: 4),
                        Text(
                          user?.phone.isNotEmpty == true
                              ? user!.phone
                              : '03000000000',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _MenuTile(
            icon: Icons.edit_rounded,
            title: 'Edit Profile',
            onTap: () => context.push(AppRoutes.editProfile),
          ),
          _MenuTile(
            icon: Icons.location_on_rounded,
            title: 'Saved Addresses',
            onTap: () => context.push(AppRoutes.addresses),
          ),
          _MenuTile(
            icon: Icons.favorite_rounded,
            title: 'Favorites',
            onTap: () => context.go(AppRoutes.favorites),
          ),
          _MenuTile(
            icon: Icons.receipt_long_rounded,
            title: 'Orders',
            onTap: () => context.go(AppRoutes.orders),
          ),
          _MenuTile(
            icon: Icons.notifications_rounded,
            title: 'Notifications',
            onTap: () => context.push(AppRoutes.notifications),
          ),
          _MenuTile(
            icon: Icons.settings_rounded,
            title: 'Settings',
            onTap: () => context.push(AppRoutes.settings),
          ),
          _MenuTile(
            icon: Icons.storefront_rounded,
            title: 'Restaurant Owner Panel',
            onTap: () => context.push(AppRoutes.ownerDashboard),
          ),
          _MenuTile(
            icon: Icons.admin_panel_settings_rounded,
            title: 'Admin Panel',
            onTap: () => context.push(AppRoutes.adminDashboard),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.roleSelection);
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
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
