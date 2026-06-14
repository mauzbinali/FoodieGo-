import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(userNotificationsProvider);
    final userId = ref.watch(authProvider).user?.uid ?? 'demo_user';
    return FoodieGoScaffold(
      title: 'Notifications',
      actions: [
        TextButton(
          onPressed: () => ref
              .read(notificationActionsProvider.notifier)
              .markAllAsRead(userId),
          child: const Text('Read all'),
        ),
      ],
      slivers: [
        notifications.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SliverFillRemaining(
            child: EmptyState(
              icon: Icons.notifications_off_rounded,
              title: 'Notifications unavailable',
              subtitle: 'Please try again later.',
            ),
          ),
          data: (items) {
            if (items.isEmpty) {
              return const SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.notifications_none_rounded,
                  title: 'No notifications',
                  subtitle: 'Order and offer updates will appear here.',
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item.isRead
                            ? AppColors.surfaceVariant
                            : AppColors.primarySurface,
                        child: Icon(
                          Icons.notifications_rounded,
                          color: item.isRead
                              ? AppColors.textTertiary
                              : AppColors.primary,
                        ),
                      ),
                      title: Text(item.title),
                      subtitle: Text(item.body),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () => ref
                            .read(notificationActionsProvider.notifier)
                            .deleteNotification(item.id),
                      ),
                      onTap: () => ref
                          .read(notificationActionsProvider.notifier)
                          .markAsRead(item.id),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
