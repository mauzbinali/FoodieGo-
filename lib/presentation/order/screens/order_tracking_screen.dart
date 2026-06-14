import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/order_provider.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  static const _statuses = [
    AppConstants.orderPlaced,
    AppConstants.orderConfirmed,
    AppConstants.preparingFood,
    AppConstants.readyForPickup,
    AppConstants.riderAssigned,
    AppConstants.outForDelivery,
    AppConstants.delivered,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderByIdProvider(orderId));
    return FoodieGoScaffold(
      title: 'Track Order',
      slivers: [
        orderAsync.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SliverFillRemaining(
            child: EmptyState(
              icon: Icons.delivery_dining_rounded,
              title: 'Tracking unavailable',
              subtitle: 'Please try again later.',
            ),
          ),
          data: (order) {
            final currentIndex = order == null
                ? 2
                : _statuses
                      .indexOf(order.status)
                      .clamp(0, _statuses.length - 1);
            return SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    height: 190,
                    decoration: BoxDecoration(
                      color: AppColors.secondarySurface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: _MapPainter()),
                        ),
                        const Center(
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.delivery_dining_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 18,
                          top: 18,
                          child: StatusPill(
                            label: 'Mock live map',
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.primarySurface,
                        child: Icon(Icons.person_rounded),
                      ),
                      title: const Text('Rider: Ahmed Raza'),
                      subtitle: const Text('ETA 18 min • Honda CD 70'),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.phone_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Timeline', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 10),
                  ..._statuses.asMap().entries.map((entry) {
                    final done = entry.key <= currentIndex;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: done
                            ? AppColors.primary
                            : AppColors.border,
                        child: Icon(
                          done
                              ? Icons.check_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: done ? Colors.white : AppColors.textTertiary,
                        ),
                      ),
                      title: Text(entry.value),
                      subtitle: Text(done ? 'Completed' : 'Pending'),
                    );
                  }),
                ]),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.18)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(20, size.height - 30)
      ..quadraticBezierTo(size.width * 0.35, 20, size.width * 0.62, 70)
      ..quadraticBezierTo(size.width * 0.78, 100, size.width - 24, 34);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
