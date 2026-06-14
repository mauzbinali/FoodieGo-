import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../shared/foodiego_ui.dart';
import '../providers/search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    return FoodieGoScaffold(
      title: 'Search',
      slivers: [
        SliverToBoxAdapter(
          child: AppSearchBar(
            controller: _controller,
            onChanged: (value) =>
                ref.read(searchProvider.notifier).search(value),
          ),
        ),
        if (state.query.isEmpty && state.recentSearches.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 8,
                children: state.recentSearches
                    .map(
                      (query) => ActionChip(
                        label: Text(query),
                        onPressed: () {
                          _controller.text = query;
                          ref.read(searchProvider.notifier).search(query);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        if (state.isLoading)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (state.results.isEmpty)
          SliverFillRemaining(
            child: EmptyState(
              icon: Icons.search_rounded,
              title: 'Find your next meal',
              subtitle: 'Search burgers, pizza, restaurants, or categories.',
              buttonLabel: 'Browse Restaurants',
              onPressed: () => context.push(AppRoutes.restaurantList),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.separated(
              itemCount: state.results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final result = state.results[index];
                if (result.restaurant != null) {
                  return RestaurantCard(restaurant: result.restaurant!);
                }
                return FoodTile(food: result.food!);
              },
            ),
          ),
      ],
    );
  }
}
