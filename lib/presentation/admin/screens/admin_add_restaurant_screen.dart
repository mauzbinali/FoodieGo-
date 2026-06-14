import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/restaurant_model.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/demo_management_provider.dart';

class AdminAddRestaurantScreen extends ConsumerStatefulWidget {
  const AdminAddRestaurantScreen({super.key});

  @override
  ConsumerState<AdminAddRestaurantScreen> createState() =>
      _AdminAddRestaurantScreenState();
}

class _AdminAddRestaurantScreenState
    extends ConsumerState<AdminAddRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _address = TextEditingController(text: 'Lahore, Pakistan');
  final _image = TextEditingController();
  final _deliveryTime = TextEditingController(text: '30');
  final _deliveryFee = TextEditingController(text: '150');
  final Set<String> _categories = {'Burgers'};
  bool _isOpen = true;
  bool _isFeatured = true;
  bool _isPopular = false;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _address.dispose();
    _image.dispose();
    _deliveryTime.dispose();
    _deliveryFee.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose at least one category.')),
      );
      return;
    }

    final notifier = ref.read(demoManagementProvider.notifier);
    final name = _name.text.trim();
    final id = notifier.uniqueRestaurantId(name);
    final category = _categories.first;
    final restaurant = RestaurantModel(
      id: id,
      ownerId: 'owner_$id',
      name: name,
      description: _description.text.trim().isEmpty
          ? 'Fresh meals from $name, prepared for quick delivery.'
          : _description.text.trim(),
      image: _image.text.trim().isEmpty
          ? imageForCategory(category)
          : _image.text.trim(),
      logo: '',
      categories: _categories.toList(),
      rating: 4.5,
      reviewCount: 0,
      deliveryTime: int.tryParse(_deliveryTime.text.trim()) ?? 30,
      deliveryFee: double.tryParse(_deliveryFee.text.trim()) ?? 150,
      distance: 2.4,
      latitude: AppConstants.defaultLatitude,
      longitude: AppConstants.defaultLongitude,
      address: _address.text.trim(),
      isOpen: _isOpen,
      isFeatured: _isFeatured,
      isPopular: _isPopular,
      createdAt: DateTime.now(),
    );

    notifier.addRestaurant(restaurant);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${restaurant.name} added.')));
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.adminRestaurants);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FoodieGoScaffold(
      title: 'Add Restaurant',
      fallbackRoute: AppRoutes.adminRestaurants,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    label: 'Restaurant Name',
                    controller: _name,
                    prefixIcon: Icons.storefront_rounded,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Restaurant name is required'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Description',
                    controller: _description,
                    maxLines: 3,
                    prefixIcon: Icons.notes_rounded,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Address',
                    controller: _address,
                    prefixIcon: Icons.place_rounded,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Address is required'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    label: 'Image URL',
                    hint: 'Leave blank for a food image',
                    controller: _image,
                    prefixIcon: Icons.image_rounded,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Delivery Min',
                          controller: _deliveryTime,
                          prefixIcon: Icons.timer_rounded,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          label: 'Delivery Fee',
                          controller: _deliveryFee,
                          prefixIcon: Icons.delivery_dining_rounded,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: defaultFoodCategories().map((category) {
                      final selected = _categories.contains(category);
                      return FilterChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              _categories.add(category);
                            } else {
                              _categories.remove(category);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  SwitchListTile.adaptive(
                    value: _isOpen,
                    onChanged: (value) => setState(() => _isOpen = value),
                    title: const Text('Open for orders'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile.adaptive(
                    value: _isFeatured,
                    onChanged: (value) => setState(() => _isFeatured = value),
                    title: const Text('Featured on home'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  SwitchListTile.adaptive(
                    value: _isPopular,
                    onChanged: (value) => setState(() => _isPopular = value),
                    title: const Text('Popular restaurant'),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Save Restaurant'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
