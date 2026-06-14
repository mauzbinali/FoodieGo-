import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../shared/foodiego_ui.dart';

class OwnerOrdersScreen extends StatelessWidget {
  const OwnerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statuses = [
      AppConstants.orderPlaced,
      AppConstants.orderConfirmed,
      AppConstants.preparingFood,
      AppConstants.outForDelivery,
    ];
    return FoodieGoScaffold(
      title: 'Order Management',
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList.separated(
            itemCount: statuses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text('Order #FG-${1024 + index}'),
                subtitle: Text(statuses[index]),
                trailing: PopupMenuButton<String>(
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'accept', child: Text('Accept')),
                    PopupMenuItem(value: 'reject', child: Text('Reject')),
                    PopupMenuItem(
                      value: 'update',
                      child: Text('Update Status'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
