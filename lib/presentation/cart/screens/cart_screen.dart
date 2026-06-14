import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repositories/coupon_repository.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _couponController = TextEditingController();
  String? _couponMessage;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        title: const Text('Cart'),
      ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () => context.push(AppRoutes.checkout),
                  child: Text(
                    'Proceed to Checkout • ${formatCurrency(cart.total)}',
                  ),
                ),
              ),
            ),
      body: cart.isEmpty
          ? EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              subtitle: 'Add meals from restaurants and they will appear here.',
              buttonLabel: 'Browse Food',
              onPressed: () => context.go(AppRoutes.home),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  cart.restaurantName ?? 'Cart',
                  style: AppTextStyles.titleLarge,
                ),
                const SizedBox(height: 12),
                ...cart.items.map(
                  (item) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.image,
                              width: 74,
                              height: 74,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 74,
                                height: 74,
                                color: AppColors.primarySurface,
                                child: const Icon(Icons.fastfood_rounded),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: AppTextStyles.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.selectedCustomizations.isEmpty
                                      ? 'No customizations'
                                      : item.selectedCustomizations.join(', '),
                                  style: AppTextStyles.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  formatCurrency(item.totalPrice),
                                  style: AppTextStyles.priceSmall,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () => notifier.removeItem(item.id),
                                icon: const Icon(Icons.close_rounded),
                              ),
                              Row(
                                children: [
                                  IconButton.filledTonal(
                                    onPressed: () => notifier.updateQuantity(
                                      item.id,
                                      item.quantity - 1,
                                    ),
                                    icon: const Icon(Icons.remove_rounded),
                                  ),
                                  Text('${item.quantity}'),
                                  IconButton.filledTonal(
                                    onPressed: () => notifier.updateQuantity(
                                      item.id,
                                      item.quantity + 1,
                                    ),
                                    icon: const Icon(Icons.add_rounded),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Coupon', style: AppTextStyles.titleLarge),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _couponController,
                                decoration: const InputDecoration(
                                  hintText: 'WELCOME20',
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            FilledButton(
                              onPressed: () async {
                                final coupon = await ref
                                    .read(couponRepositoryProvider)
                                    .validateCoupon(
                                      _couponController.text,
                                      cart.subtotal,
                                    );
                                setState(() {
                                  _couponMessage = coupon == null
                                      ? 'Coupon unavailable'
                                      : '${coupon.code} applied';
                                });
                                if (coupon != null) {
                                  notifier.applyCoupon(
                                    coupon.code,
                                    coupon.calculateDiscount(
                                      cart.subtotal,
                                      cart.deliveryFee,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Apply'),
                            ),
                          ],
                        ),
                        if (_couponMessage != null) ...[
                          const SizedBox(height: 8),
                          Text(_couponMessage!, style: AppTextStyles.bodySmall),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        PriceRow(label: 'Subtotal', value: cart.subtotal),
                        PriceRow(label: 'Tax', value: cart.tax),
                        PriceRow(
                          label: 'Delivery Fee',
                          value: cart.deliveryFee,
                        ),
                        PriceRow(label: 'Discount', value: -cart.discount),
                        const Divider(height: 24),
                        PriceRow(
                          label: 'Grand Total',
                          value: cart.total,
                          highlight: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
