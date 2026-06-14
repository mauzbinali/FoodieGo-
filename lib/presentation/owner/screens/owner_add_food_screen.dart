import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/food_model.dart';
import '../../admin/providers/demo_management_provider.dart';

class OwnerAddFoodScreen extends ConsumerStatefulWidget {
  final String? foodId;

  const OwnerAddFoodScreen({super.key, this.foodId});

  @override
  ConsumerState<OwnerAddFoodScreen> createState() => _OwnerAddFoodScreenState();
}

class _OwnerAddFoodScreenState extends ConsumerState<OwnerAddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  final _image = TextEditingController();
  final _preparationTime = TextEditingController(text: '15');
  String _category = 'Burgers';
  bool _isAvailable = true;
  bool _isPopular = true;

  FoodModel? get _editingFood {
    if (widget.foodId == null) return null;
    final foods = ref.read(demoManagementProvider).foods;
    for (final food in foods) {
      if (food.id == widget.foodId) return food;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final food = _editingFood;
    if (food == null) return;
    _name.text = food.name;
    _price.text = food.price.toStringAsFixed(0);
    _description.text = food.description;
    _image.text = food.image;
    _preparationTime.text = food.preparationTime.toString();
    _category = food.category;
    _isAvailable = food.isAvailable;
    _isPopular = food.isPopular;
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _description.dispose();
    _image.dispose();
    _preparationTime.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(demoManagementProvider.notifier);
    final restaurant =
        notifier.restaurantById('mcdonalds') ??
        ref.read(demoManagementProvider).restaurants.firstOrNull;
    if (restaurant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a restaurant before saving food.')),
      );
      return;
    }

    final existing = _editingFood;
    final name = _name.text.trim();
    final food = FoodModel(
      id:
          existing?.id ??
          notifier.uniqueFoodId(restaurantId: restaurant.id, name: name),
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
      oldPrice: existing?.oldPrice ?? 0,
      rating: existing?.rating ?? 4.4,
      reviewCount: existing?.reviewCount ?? 0,
      preparationTime: int.tryParse(_preparationTime.text.trim()) ?? 15,
      isAvailable: _isAvailable,
      isPopular: _isPopular,
      customizations:
          existing?.customizations ??
          const ['Extra Cheese', 'Extra Sauce', 'No Spice'],
      createdAt: existing?.createdAt ?? DateTime.now(),
    );

    if (existing == null) {
      notifier.addFood(food);
    } else {
      notifier.updateFood(food);
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${food.name} saved.')));
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.ownerMenuManagement);
    }
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
              context.go(AppRoutes.ownerMenuManagement);
            }
          },
        ),
        title: Text(widget.foodId == null ? 'Add Food' : 'Edit Food'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'Food Name',
                  controller: _name,
                  prefixIcon: Icons.fastfood_rounded,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Food name is required'
                      : null,
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_rounded),
                  ),
                  items: AppConstants.foodCategories
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _category = value!),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Description',
                  controller: _description,
                  maxLines: 4,
                  prefixIcon: Icons.notes_rounded,
                ),
                const SizedBox(height: 12),
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
                  onChanged: (value) => setState(() => _isAvailable = value),
                  title: const Text('Available'),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile.adaptive(
                  value: _isPopular,
                  onChanged: (value) => setState(() => _isPopular = value),
                  title: const Text('Popular item'),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save Food'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
