import 'food_model.dart';
import 'restaurant_model.dart';

enum SearchResultType { restaurant, food }

class SearchResultModel {
  final SearchResultType type;
  final RestaurantModel? restaurant;
  final FoodModel? food;

  const SearchResultModel.restaurant(this.restaurant)
    : type = SearchResultType.restaurant,
      food = null;

  const SearchResultModel.food(this.food)
    : type = SearchResultType.food,
      restaurant = null;

  String get title =>
      type == SearchResultType.restaurant ? restaurant!.name : food!.name;

  String get subtitle => type == SearchResultType.restaurant
      ? restaurant!.address
      : 'Rs. ${food!.price.toInt()} - ${food!.restaurantName}';

  String get image =>
      type == SearchResultType.restaurant ? restaurant!.image : food!.image;
}
