import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/address_model.dart';
import '../providers/address_provider.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  final String? addressId;

  const AddAddressScreen({super.key, this.addressId});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final _title = TextEditingController(text: 'Home');
  final _street = TextEditingController(text: 'House 12, Main Boulevard');
  final _city = TextEditingController(text: 'Lahore');
  final _postal = TextEditingController(text: '54000');
  final _notes = TextEditingController();
  AddressType _type = AddressType.home;

  @override
  void dispose() {
    _title.dispose();
    _street.dispose();
    _city.dispose();
    _postal.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.addresses);
            }
          },
        ),
        title: const Text('Add Address'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.secondarySurface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Icon(
                Icons.map_rounded,
                size: 56,
                color: AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: AddressType.values
                .map(
                  (type) => ChoiceChip(
                    selected: _type == type,
                    label: Text(
                      type.name[0].toUpperCase() + type.name.substring(1),
                    ),
                    onSelected: (_) => setState(() => _type = type),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          AppTextField(label: 'Address Title', controller: _title),
          const SizedBox(height: 12),
          AppTextField(label: 'Street Address', controller: _street),
          const SizedBox(height: 12),
          AppTextField(label: 'City', controller: _city),
          const SizedBox(height: 12),
          AppTextField(label: 'Postal Code', controller: _postal),
          const SizedBox(height: 12),
          AppTextField(label: 'Notes', controller: _notes, maxLines: 3),
          const SizedBox(height: 22),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(addressProvider.notifier)
                  .addAddress(
                    title: _title.text,
                    type: _type,
                    streetAddress: _street.text,
                    city: _city.text,
                    postalCode: _postal.text,
                    notes: _notes.text,
                    latitude: AppConstants.defaultLatitude,
                    longitude: AppConstants.defaultLongitude,
                    isDefault: true,
                  );
              if (context.mounted) context.pop();
            },
            child: const Text('Save Address'),
          ),
        ],
      ),
    );
  }
}
