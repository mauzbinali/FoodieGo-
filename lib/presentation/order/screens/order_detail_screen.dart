import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/order_provider.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderByIdProvider(orderId));
    return FoodieGoScaffold(
      title: 'Order Detail',
      slivers: [
        orderAsync.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SliverFillRemaining(
            child: EmptyState(
              icon: Icons.receipt_long_rounded,
              title: 'Order unavailable',
              subtitle: 'Please try again later.',
            ),
          ),
          data: (order) {
            if (order == null) {
              return const SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.receipt_long_rounded,
                  title: 'Order not found',
                  subtitle: 'This order could not be found.',
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    child: ListTile(
                      title: Text(order.restaurantName),
                      subtitle: Text(order.status),
                      trailing: Text(formatCurrency(order.totalPrice)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Items', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 8),
                  ...order.items.map(
                    (item) => ListTile(
                      title: Text(item.name),
                      subtitle: Text('Qty ${item.quantity}'),
                      trailing: Text(formatCurrency(item.totalPrice)),
                    ),
                  ),
                  const Divider(height: 28),
                  PriceRow(label: 'Subtotal', value: order.subtotal),
                  PriceRow(label: 'Tax', value: order.tax),
                  PriceRow(label: 'Delivery', value: order.deliveryFee),
                  PriceRow(label: 'Discount', value: -order.discount),
                  PriceRow(label: 'Tip', value: order.tip),
                  PriceRow(
                    label: 'Total',
                    value: order.totalPrice,
                    highlight: true,
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: () => context.push(
                      '${AppRoutes.orderTrackingPath}/${order.id}',
                    ),
                    icon: const Icon(Icons.delivery_dining_rounded),
                    label: const Text('Track Order'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Receipt downloaded (demo).'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf_rounded),
                    label: const Text('Download Receipt'),
                  ),
                  TextButton.icon(
                    onPressed: () => context.go(AppRoutes.home),
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: AppColors.primary,
                    ),
                    label: const Text('Reorder similar food'),
                  ),
                ]),
              ),
            );
          },
        ),
      ],
    );
  }
}
