import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/food_model.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/demo_management_provider.dart';

class AdminAddFoodScreen extends ConsumerStatefulWidget {
  const AdminAddFoodScreen({super.key});

  @override
  ConsumerState<AdminAddFoodScreen> createState() => _AdminAddFoodScreenState();
}

class _AdminAddFoodScreenState extends ConsumerState<AdminAddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _image = TextEditingController();
  final _preparationTime = TextEditingController(text: '15');
  String? _restaurantId;
  String _category = 'Burgers';
  bool _isAvailable = true;
  bool _isPopular = true;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    _image.dispose();
    _preparationTime.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(demoManagementProvider.notifier);
    final restaurant = notifier.restaurantById(_restaurantId ?? '');
    if (restaurant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a restaurant first.')),
      );
      return;
    }

    final name = _name.text.trim();
    final food = FoodModel(
      id: notifier.uniqueFoodId(restaurantId: restaurant.id, name: name),
      restaurantId: restaurant.id,
      restaurantName: restaurant.name,
      name: name,
      description: _description.text.trim().isEmpty
          ? '$name from ${restaurant.name}, prepared fresh for delivery.'
          : _description.text.trim(),
      image: _image.text.trim().isEmpty
          ? imageForCategory(_category)
          : _image.text.trim(),
      category: _category,
      price: double.tryParse(_price.text.trim()) ?? 0,
      rating: 4.4,
      reviewCount: 0,
      preparationTime: int.tryParse(_preparationTime.text.trim()) ?? 15,
      isAvailable: _isAvailable,
      isPopular: _isPopular,
      customizations: const ['Extra Cheese', 'Extra Sauce', 'No Spice'],
      createdAt: DateTime.now(),
    );

    notifier.addFood(food);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${food.name} added.')));
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.adminFoods);
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = ref.watch(demoManagementProvider).restaurants;
    _restaurantId ??= restaurants.isEmpty ? null : restaurants.first.id;

    return FoodieGoScaffold(
      title: 'Add Food',
      fallbackRoute: AppRoutes.adminFoods,
      slivers: [
        if (restaurants.isEmpty)
          SliverFillRemaining(
            child: EmptyState(
              icon: Icons.storefront_rounded,
              title: 'No restaurants yet',
              subtitle: 'Create a restaurant before adding menu items.',
              buttonLabel: 'Add Restaurant',
              onPressed: () => context.go(AppRoutes.adminAddRestaurant),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Restaurant',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _restaurantId,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.storefront_rounded),
                      ),
                      items: restaurants
                          .map(
                            (restaurant) => DropdownMenuItem(
                              value: restaurant.id,
                              child: Text(restaurant.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _restaurantId = value),
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Food Name',
                      controller: _name,
                      prefixIcon: Icons.fastfood_rounded,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Food name is required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Price',
                            controller: _price,
                            prefixIcon: Icons.payments_rounded,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              final price = double.tryParse(value ?? '');
                              return price == null || price <= 0
                                  ? 'Enter price'
                                  : null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            label: 'Prep Min',
                            controller: _preparationTime,
                            prefixIcon: Icons.timer_rounded,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category_rounded),
                      ),
                      items: AppConstants.foodCategories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _category = value!),
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
                      label: 'Image URL',
                      hint: 'Leave blank for a category image',
                      controller: _image,
                      prefixIcon: Icons.image_rounded,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      value: _isAvailable,
                      onChanged: (value) =>
                          setState(() => _isAvailable = value),
                      title: const Text('Available'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile.adaptive(
                      value: _isPopular,
                      onChanged: (value) => setState(() => _isPopular = value),
                      title: const Text('Popular item'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Save Food'),
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
