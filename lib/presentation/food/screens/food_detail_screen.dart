import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_image.dart';
import '../../cart/providers/cart_provider.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/food_provider.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  final String foodId;

  const FoodDetailScreen({super.key, required this.foodId});

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  int _quantity = 1;
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final foodAsync = ref.watch(foodByIdProvider(widget.foodId));
    final isFavorite = ref.watch(isFavoriteFoodProvider(widget.foodId));

    return foodAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(
        body: EmptyState(
          icon: Icons.fastfood_rounded,
          title: 'Food unavailable',
          subtitle: 'Please try again later.',
        ),
      ),
      data: (food) {
        if (food == null) {
          return const Scaffold(
            body: EmptyState(
              icon: Icons.fastfood_rounded,
              title: 'Food not found',
              subtitle: 'This item is not available anymore.',
            ),
          );
        }

        final customizationPrice = _selected.length * 80.0;
        final total = (food.price + customizationPrice) * _quantity;

        return Scaffold(
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                onPressed: () {
                  final cart = ref.read(cartProvider.notifier);
                  if (!cart.canAddFood(food)) {
                    cart.clearCart();
                  }
                  cart.addFood(
                    food: food,
                    quantity: _quantity,
                    selectedCustomizations: _selected.toList(),
                    customizationPrice: customizationPrice,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${food.name} added to cart')),
                  );
                },
                icon: const Icon(Icons.shopping_bag_rounded),
                label: Text('Add to Cart • Rs.${total.toStringAsFixed(0)}'),
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                leading: IconButton.filledTonal(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.home);
                    }
                  },
                ),
                actions: [
                  IconButton.filledTonal(
                    onPressed: () => ref
                        .read(favoritesProvider.notifier)
                        .toggleFavoriteFood(food.id),
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: CustomImage(imageUrl: food.image),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(food.name, style: AppTextStyles.displaySmall),
                    const SizedBox(height: 8),
                    Text(food.restaurantName, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        StatusPill(
                          label: 'Rs.${food.price.toInt()}',
                          color: AppColors.primary,
                        ),
                        StatusPill(
                          label: '${food.rating.toStringAsFixed(1)} ★',
                          color: AppColors.star,
                          darkText: true,
                        ),
                        StatusPill(
                          label: '${food.preparationTime} min',
                          color: AppColors.secondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(food.description),
                    const SizedBox(height: 24),
                    Text('Customization', style: AppTextStyles.titleLarge),
                    const SizedBox(height: 10),
                    ...food.customizations.map(
                      (option) => CheckboxListTile(
                        value: _selected.contains(option),
                        onChanged: (value) => setState(() {
                          if (value ?? false) {
                            _selected.add(option);
                          } else {
                            _selected.remove(option);
                          }
                        }),
                        title: Text(option),
                        subtitle: const Text('+ Rs.80'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text('Quantity', style: AppTextStyles.titleLarge),
                        const Spacer(),
                        IconButton.filledTonal(
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                          icon: const Icon(Icons.remove_rounded),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '$_quantity',
                            style: AppTextStyles.titleLarge,
                          ),
                        ),
                        IconButton.filled(
                          onPressed: () => setState(() => _quantity++),
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            MiniMeta(
                              icon: Icons.local_fire_department_rounded,
                              text: 'Calories: 520 kcal',
                            ),
                            SizedBox(height: 8),
                            MiniMeta(
                              icon: Icons.eco_rounded,
                              text: 'Ingredients: Chicken, cheese, herbs',
                            ),
                            SizedBox(height: 8),
                            MiniMeta(
                              icon: Icons.warning_amber_rounded,
                              text: 'Allergens: Dairy, gluten',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
