import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/banner_model.dart';
import '../../../data/models/restaurant_model.dart';
import '../../../data/repositories/demo_data.dart';
import '../../../data/repositories/restaurant_repository.dart';

final bannersProvider = Provider<List<BannerModel>>((ref) => DemoData.banners);

final restaurantsProvider = FutureProvider<List<RestaurantModel>>((ref) {
  return ref.watch(restaurantRepositoryProvider).getAllRestaurants();
});

final featuredRestaurantsProvider = FutureProvider<List<RestaurantModel>>((
  ref,
) {
  return ref.watch(restaurantRepositoryProvider).getFeaturedRestaurants();
});

final popularRestaurantsProvider = FutureProvider<List<RestaurantModel>>((ref) {
  return ref.watch(restaurantRepositoryProvider).getPopularRestaurants();
});

final topRatedRestaurantsProvider = FutureProvider<List<RestaurantModel>>((
  ref,
) {
  return ref.watch(restaurantRepositoryProvider).getTopRatedRestaurants();
});

final restaurantsByCategoryProvider =
    FutureProvider.family<List<RestaurantModel>, String>((ref, category) {
      return ref
          .watch(restaurantRepositoryProvider)
          .getRestaurantsByCategory(category);
    });

final restaurantByIdProvider = FutureProvider.family<RestaurantModel?, String>((
  ref,
  id,
) {
  return ref.watch(restaurantRepositoryProvider).getRestaurantById(id);
});

final restaurantStreamProvider =
    StreamProvider.family<RestaurantModel?, String>((ref, id) {
      return ref.watch(restaurantRepositoryProvider).getRestaurantStream(id);
    });

final ownerRestaurantProvider = FutureProvider.family<RestaurantModel?, String>(
  (ref, ownerId) {
    return ref.watch(restaurantRepositoryProvider).getOwnerRestaurant(ownerId);
  },
);
