import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  Future<void> _continueAs(
    BuildContext context,
    WidgetRef ref,
    String role,
  ) async {
    await ref.read(authProvider.notifier).continueAsDemoRole(role);
    if (!context.mounted) return;
    context.go(_routeForRole(role));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            20,
            18,
            20,
            MediaQuery.of(context).padding.bottom + 24,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.22),
                    blurRadius: 26,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu_rounded,
                      color: AppColors.primary,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'FoodieGo',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose your workspace',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _RoleCard(
              icon: Icons.delivery_dining_rounded,
              title: 'Customer',
              subtitle: 'Browse restaurants, place orders, and track delivery.',
              color: AppColors.primary,
              enabled: !auth.isLoading,
              onTap: () => _continueAs(context, ref, AppConstants.roleCustomer),
            ),
            const SizedBox(height: 12),
            _RoleCard(
              icon: Icons.storefront_rounded,
              title: 'Restaurant Owner',
              subtitle: 'Manage menu, orders, ratings, and availability.',
              color: AppColors.secondary,
              enabled: !auth.isLoading,
              onTap: () => _continueAs(context, ref, AppConstants.roleOwner),
            ),
            const SizedBox(height: 12),
            _RoleCard(
              icon: Icons.admin_panel_settings_rounded,
              title: 'Admin Panel',
              subtitle:
                  'Control restaurants, foods, users, coupons, and orders.',
              color: AppColors.info,
              enabled: !auth.isLoading,
              onTap: () => _continueAs(context, ref, AppConstants.roleAdmin),
            ),
            const SizedBox(height: 22),
            if (auth.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push(AppRoutes.login),
                      child: const Text('Sign In'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push(AppRoutes.register),
                      child: const Text('Create Account'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.withValues(alpha: 0.12),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

String _routeForRole(String role) {
  return switch (role) {
    AppConstants.roleAdmin => AppRoutes.adminDashboard,
    AppConstants.roleOwner => AppRoutes.ownerDashboard,
    _ => AppRoutes.home,
  };
}
