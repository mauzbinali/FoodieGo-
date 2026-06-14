import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/address_model.dart';
import '../../address/providers/address_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/order_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _payment = AppConstants.cashOnDelivery;
  double _tip = 0;
  final _notes = TextEditingController();
  final _instructions = TextEditingController();

  @override
  void dispose() {
    _notes.dispose();
    _instructions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final selectedAddress =
        ref.watch(selectedAddressProvider) ?? _fallbackAddress();
    final orderState = ref.watch(orderProvider);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.cart);
            }
          },
        ),
        title: const Text('Checkout'),
      ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: orderState.isLoading
                      ? null
                      : () async {
                          final orderId = await ref
                              .read(orderProvider.notifier)
                              .placeOrder(
                                userId: user?.uid ?? 'demo_user',
                                restaurantId: cart.restaurantId ?? '',
                                restaurantName: cart.restaurantName ?? '',
                                restaurantImage: cart.items.first.image,
                                cartItems: cart.items,
                                subtotal: cart.subtotal,
                                tax: cart.tax,
                                deliveryFee: cart.deliveryFee,
                                discount: cart.discount,
                                tip: _tip,
                                totalPrice: cart.total + _tip,
                                deliveryAddress: selectedAddress,
                                paymentMethod: _payment,
                                couponCode: cart.couponCode,
                                orderNotes: _notes.text,
                                deliveryInstructions: _instructions.text,
                              );
                          if (orderId != null && context.mounted) {
                            ref.read(cartProvider.notifier).clearCart();
                            context.go(
                              '${AppRoutes.orderSuccess}?orderId=$orderId',
                            );
                          }
                        },
                  child: orderState.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          'Place Order • ${formatCurrency(cart.total + _tip)}',
                        ),
                ),
              ),
            ),
      body: cart.isEmpty
          ? EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Cart is empty',
              subtitle: 'Add an item before checkout.',
              buttonLabel: 'Go Home',
              onPressed: () => context.go(AppRoutes.home),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text(selectedAddress.title),
                    subtitle: Text(selectedAddress.fullAddress),
                    trailing: TextButton(
                      onPressed: () => context.push(AppRoutes.addresses),
                      child: const Text('Change'),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Payment Method', style: AppTextStyles.titleLarge),
                const SizedBox(height: 8),
                ...[
                  AppConstants.cashOnDelivery,
                  AppConstants.creditCard,
                  AppConstants.easyPaisa,
                  AppConstants.jazzCash,
                ].map(
                  (method) => Card(
                    child: ListTile(
                      onTap: () => setState(() => _payment = method),
                      leading: Icon(
                        _payment == method
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: _payment == method
                            ? AppColors.primary
                            : AppColors.textTertiary,
                      ),
                      title: Text(method),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _notes,
                  decoration: const InputDecoration(
                    labelText: 'Order Notes',
                    hintText: 'Less spicy, extra napkins...',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _instructions,
                  decoration: const InputDecoration(
                    labelText: 'Delivery Instructions',
                    hintText: 'Call before arrival',
                  ),
                ),
                const SizedBox(height: 18),
                Text('Rider Tip', style: AppTextStyles.titleLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [0, 50, 100, 150, 200]
                      .map(
                        (tip) => ChoiceChip(
                          selected: _tip == tip,
                          label: Text(tip == 0 ? 'No tip' : 'Rs.$tip'),
                          onSelected: (_) =>
                              setState(() => _tip = tip.toDouble()),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 18),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        PriceRow(label: 'Subtotal', value: cart.subtotal),
                        PriceRow(label: 'Tax', value: cart.tax),
                        PriceRow(label: 'Delivery', value: cart.deliveryFee),
                        PriceRow(label: 'Discount', value: -cart.discount),
                        PriceRow(label: 'Rider Tip', value: _tip),
                        const Divider(height: 24),
                        PriceRow(
                          label: 'Total',
                          value: cart.total + _tip,
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

  AddressModel _fallbackAddress() {
    return AddressModel(
      id: 'default',
      userId: 'demo_user',
      title: 'Home',
      type: AddressType.home,
      streetAddress: 'House 12, Main Boulevard',
      city: 'Lahore',
      postalCode: '54000',
      latitude: AppConstants.defaultLatitude,
      longitude: AppConstants.defaultLongitude,
      isDefault: true,
      createdAt: DateTime.now(),
    );
  }
}
