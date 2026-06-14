import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/hive_service.dart';
import '../../../data/models/search_result_model.dart';
import '../../../data/repositories/food_repository.dart';
import '../../../data/repositories/restaurant_repository.dart';

class SearchState {
  final String query;
  final List<SearchResultModel> results;
  final bool isLoading;
  final String? errorMessage;
  final List<String> recentSearches;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.errorMessage,
    this.recentSearches = const [],
  });

  SearchState copyWith({
    String? query,
    List<SearchResultModel>? results,
    bool? isLoading,
    String? errorMessage,
    List<String>? recentSearches,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final RestaurantRepository _restaurantRepo;
  final FoodRepository _foodRepo;
  final HiveService _hive;

  SearchNotifier({
    required RestaurantRepository restaurantRepo,
    required FoodRepository foodRepo,
    required HiveService hive,
  }) : _restaurantRepo = restaurantRepo,
       _foodRepo = foodRepo,
       _hive = hive,
       super(const SearchState()) {
    state = state.copyWith(recentSearches: _hive.getRecentSearches());
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(query: '', results: []);
      return;
    }
    state = state.copyWith(query: trimmed, isLoading: true);
    final restaurants = await _restaurantRepo.searchRestaurants(trimmed);
    final foods = await _foodRepo.searchFoods(trimmed);
    await _hive.addRecentSearch(trimmed);
    state = state.copyWith(
      results: [
        ...restaurants.map(SearchResultModel.restaurant),
        ...foods.map(SearchResultModel.food),
      ],
      isLoading: false,
      recentSearches: _hive.getRecentSearches(),
    );
  }

  Future<void> clearRecentSearches() async {
    await _hive.clearRecentSearches();
    state = state.copyWith(recentSearches: []);
  }

  void clearResults() => state = state.copyWith(query: '', results: []);
}

final searchProvider =
    StateNotifierProvider.autoDispose<SearchNotifier, SearchState>((ref) {
      return SearchNotifier(
        restaurantRepo: ref.watch(restaurantRepositoryProvider),
        foodRepo: ref.watch(foodRepositoryProvider),
        hive: ref.watch(hiveServiceProvider),
      );
    });
