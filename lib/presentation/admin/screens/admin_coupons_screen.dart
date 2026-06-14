import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/coupon_model.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/demo_management_provider.dart';

class AdminCouponsScreen extends ConsumerWidget {
  const AdminCouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coupons = ref.watch(demoManagementProvider).coupons;
    final notifier = ref.read(demoManagementProvider.notifier);

    return FoodieGoScaffold(
      title: 'Coupons',
      fallbackRoute: AppRoutes.adminDashboard,
      actions: [
        IconButton(
          tooltip: 'Add Coupon',
          onPressed: () => _showAddCouponSheet(context, ref),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
      slivers: [
        if (coupons.isEmpty)
          SliverFillRemaining(
            child: EmptyState(
              icon: Icons.local_offer_rounded,
              title: 'No coupons yet',
              subtitle: 'Create discounts for customers.',
              buttonLabel: 'Add Coupon',
              onPressed: () => _showAddCouponSheet(context, ref),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList.separated(
              itemCount: coupons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.local_offer_rounded),
                    title: Text(coupon.code),
                    subtitle: Text(coupon.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: coupon.isActive,
                          onChanged: (_) => notifier.toggleCoupon(coupon.code),
                        ),
                        IconButton(
                          tooltip: 'Delete',
                          onPressed: () => notifier.deleteCoupon(coupon.code),
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _showAddCouponSheet(BuildContext context, WidgetRef ref) {
    final code = TextEditingController(text: 'SAVE200');
    final discount = TextEditingController(text: '200');
    final description = TextEditingController(text: 'Rs.200 off');
    final minOrder = TextEditingController(text: '1000');
    CouponType type = CouponType.flat;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Coupon',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Code',
                        controller: code,
                        prefixIcon: Icons.confirmation_number_rounded,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<CouponType>(
                        initialValue: type,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          prefixIcon: Icon(Icons.tune_rounded),
                        ),
                        items: CouponType.values
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(_couponTypeLabel(item)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => type = value ?? CouponType.flat),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        label: type == CouponType.percentage
                            ? 'Discount Percent'
                            : 'Discount Amount',
                        controller: discount,
                        prefixIcon: Icons.percent_rounded,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        label: 'Minimum Order',
                        controller: minOrder,
                        prefixIcon: Icons.shopping_bag_rounded,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        label: 'Description',
                        controller: description,
                        prefixIcon: Icons.notes_rounded,
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        onPressed: () {
                          final couponCode = code.text.trim().toUpperCase();
                          if (couponCode.isEmpty) return;
                          ref
                              .read(demoManagementProvider.notifier)
                              .addCoupon(
                                CouponModel(
                                  code: couponCode,
                                  discount:
                                      double.tryParse(discount.text.trim()) ??
                                      0,
                                  type: type,
                                  description: description.text.trim().isEmpty
                                      ? couponCode
                                      : description.text.trim(),
                                  minOrder:
                                      double.tryParse(minOrder.text.trim()) ??
                                      0,
                                  maxDiscount: type == CouponType.percentage
                                      ? 700
                                      : 0,
                                  expiryDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                ),
                              );
                          Navigator.of(sheetContext).pop();
                        },
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Save Coupon'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      code.dispose();
      discount.dispose();
      description.dispose();
      minOrder.dispose();
    });
  }
}

String _couponTypeLabel(CouponType type) {
  return switch (type) {
    CouponType.percentage => 'Percentage',
    CouponType.flat => 'Flat',
    CouponType.freeDelivery => 'Free Delivery',
  };
}
