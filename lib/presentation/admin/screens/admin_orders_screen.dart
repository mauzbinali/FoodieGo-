import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../order/providers/order_provider.dart';
import '../../shared/foodiego_ui.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(allOrdersStreamProvider);
    return FoodieGoScaffold(
      title: 'Orders',
      slivers: [
        orders.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SliverFillRemaining(
            child: EmptyState(
              icon: Icons.receipt_long_rounded,
              title: 'Orders unavailable',
              subtitle: 'Please try again later.',
            ),
          ),
          data: (items) => items.isEmpty
              ? const SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.receipt_long_rounded,
                    title: 'No orders yet',
                    subtitle: 'Customer orders will appear here.',
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = items[index];
                      return Card(
                        child: ListTile(
                          title: Text(order.restaurantName),
                          subtitle: Text(order.status),
                          trailing: Text(formatCurrency(order.totalPrice)),
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
