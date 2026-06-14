import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/restaurant_model.dart';
import '../../home/providers/restaurant_provider.dart';
import '../../shared/foodiego_ui.dart';

class RestaurantListScreen extends ConsumerStatefulWidget {
  final String? category;
  final String? title;

  const RestaurantListScreen({super.key, this.category, this.title});

  @override
  ConsumerState<RestaurantListScreen> createState() =>
      _RestaurantListScreenState();
}

class _RestaurantListScreenState extends ConsumerState<RestaurantListScreen> {
  String _sort = 'Popular';
  double _minRating = 0;

  @override
  Widget build(BuildContext context) {
    final asyncRestaurants = widget.category == null
        ? ref.watch(restaurantsProvider)
        : ref.watch(restaurantsByCategoryProvider(widget.category!));

    return FoodieGoScaffold(
      title: widget.title ?? 'Restaurants',
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  selected: _minRating >= 4.5,
                  label: const Text('4.5+ rating'),
                  onSelected: (value) => setState(() {
                    _minRating = value ? 4.5 : 0;
                  }),
                ),
                ...['Popular', 'Highest Rated', 'Nearest', 'Fastest'].map(
                  (label) => ChoiceChip(
                    selected: _sort == label,
                    label: Text(label),
                    onSelected: (_) => setState(() => _sort = label),
                  ),
                ),
              ],
            ),
          ),
        ),
        asyncRestaurants.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SliverFillRemaining(
            child: EmptyState(
              icon: Icons.cloud_off_rounded,
              title: 'Could not load restaurants',
              subtitle: 'Please check your connection and try again.',
            ),
          ),
          data: (restaurants) {
            final sorted = _sortRestaurants(
              restaurants.where((r) => r.rating >= _minRating).toList(),
            );
            if (sorted.isEmpty) {
              return const SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.restaurant_rounded,
                  title: 'No restaurants found',
                  subtitle: 'Try a different category or filter.',
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList.separated(
                itemCount: sorted.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) =>
                    RestaurantCard(restaurant: sorted[index]),
              ),
            );
          },
        ),
      ],
    );
  }

  List<RestaurantModel> _sortRestaurants(List<RestaurantModel> restaurants) {
    return switch (_sort) {
      'Highest Rated' =>
        restaurants..sort((a, b) => b.rating.compareTo(a.rating)),
      'Nearest' =>
        restaurants..sort((a, b) => a.distance.compareTo(b.distance)),
      'Fastest' =>
        restaurants..sort((a, b) => a.deliveryTime.compareTo(b.deliveryTime)),
      _ =>
        restaurants..sort((a, b) {
          if (a.isPopular == b.isPopular) return b.rating.compareTo(a.rating);
          return a.isPopular ? -1 : 1;
        }),
    };
  }
}
