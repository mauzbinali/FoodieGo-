import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/foodiego_ui.dart';
import '../providers/admin_provider.dart';

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(adminUsersProvider);
    return FoodieGoScaffold(
      title: 'Users',
      slivers: [
        users.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SliverFillRemaining(
            child: EmptyState(
              icon: Icons.people_rounded,
              title: 'Users unavailable',
              subtitle: 'Please try again later.',
            ),
          ),
          data: (items) => SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = items[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person_rounded),
                    ),
                    title: Text(user.name),
                    subtitle: Text('${user.email} • ${user.role}'),
                    trailing: Switch(
                      value: user.isActive,
                      onChanged: (value) => ref
                          .read(adminUserActionsProvider.notifier)
                          .toggleUserStatus(user.uid, value),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
