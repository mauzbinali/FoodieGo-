import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../data/models/order_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/order_provider.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authProvider).user?.uid ?? 'demo_user';
    final orders = ref.watch(userOrdersStreamProvider(userId));
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Current'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: orders.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const EmptyState(
            icon: Icons.receipt_long_rounded,
            title: 'Could not load orders',
            subtitle: 'Please try again later.',
          ),
          data: (items) => TabBarView(
            children: [
              _OrderList(orders: items.where((o) => o.isActive).toList()),
              _OrderList(orders: items.where((o) => o.isDelivered).toList()),
              _OrderList(orders: items.where((o) => o.isCancelled).toList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<OrderModel> orders;

  const _OrderList({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return EmptyState(
        icon: Icons.receipt_long_rounded,
        title: 'No orders here',
        subtitle: 'Your orders will appear after checkout.',
        buttonLabel: 'Order Food',
        onPressed: () => context.go(AppRoutes.home),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          child: ListTile(
            title: Text(order.restaurantName),
            subtitle: Text('${order.status} • ${order.totalItems} items'),
            trailing: Text(formatCurrency(order.totalPrice)),
            onTap: () =>
                context.push('${AppRoutes.orderDetailPath}/${order.id}'),
          ),
        );
      },
    );
  }
}
