import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/address_provider.dart';

class AddressScreen extends ConsumerWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addressProvider);
    return FoodieGoScaffold(
      title: 'Saved Addresses',
      actions: [
        IconButton(
          onPressed: () => context.push(AppRoutes.addAddress),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
      slivers: [
        if (state.addresses.isEmpty)
          SliverFillRemaining(
            child: EmptyState(
              icon: Icons.location_on_outlined,
              title: 'No saved addresses',
              subtitle: 'Add home, office, university, or custom addresses.',
              buttonLabel: 'Add Address',
              onPressed: () => context.push(AppRoutes.addAddress),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList.separated(
              itemCount: state.addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final address = state.addresses[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text(address.title),
                    subtitle: Text(address.fullAddress),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () => ref
                          .read(addressProvider.notifier)
                          .deleteAddress(address.id),
                    ),
                    onTap: () => ref
                        .read(addressProvider.notifier)
                        .selectAddress(address),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
