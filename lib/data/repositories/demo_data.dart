import '../../core/constants/app_constants.dart';
import '../models/banner_model.dart';
import '../models/coupon_model.dart';
import '../models/food_model.dart';
import '../models/notification_model.dart';
import '../models/restaurant_model.dart';
import '../models/review_model.dart';

class DemoData {
  DemoData._();

  static final DateTime _now = DateTime.now();

  static final List<RestaurantModel> restaurants = [
    _restaurant(
      id: 'mcdonalds',
      ownerId: 'owner_mcdonalds',
      name: "McDonald's",
      description:
          'World-famous burgers, fries, nuggets, desserts, and drinks.',
      image: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=1200',
      categories: const ['Burgers', 'Fast Food', 'Drinks'],
      rating: 4.7,
      reviewCount: 1240,
      deliveryTime: 24,
      deliveryFee: 150,
      distance: 2.1,
      address: 'MM Alam Road, Lahore',
      isFeatured: true,
      isPopular: true,
      lat: 31.5204,
      lng: 74.3587,
    ),
    _restaurant(
      id: 'kfc',
      ownerId: 'owner_kfc',
      name: 'KFC',
      description:
          'Crispy fried chicken, zingers, wings, wraps, and value deals.',
      image: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=1200',
      categories: const ['Fast Food', 'BBQ', 'Burgers'],
      rating: 4.6,
      reviewCount: 1030,
      deliveryTime: 28,
      deliveryFee: 170,
      distance: 3.4,
      address: 'Gulberg, Lahore',
      isFeatured: true,
      isPopular: true,
      lat: 31.515,
      lng: 74.344,
    ),
    _restaurant(
      id: 'pizza_hut',
      ownerId: 'owner_pizza_hut',
      name: 'Pizza Hut',
      description: 'Pan pizzas, pasta, garlic bread, and indulgent desserts.',
      image:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=1200',
      categories: const ['Pizza', 'Fast Food', 'Desserts'],
      rating: 4.5,
      reviewCount: 870,
      deliveryTime: 32,
      deliveryFee: 200,
      distance: 4.2,
      address: 'DHA Phase 3, Lahore',
      isFeatured: true,
      lat: 31.531,
      lng: 74.352,
    ),
    _restaurant(
      id: 'dominos',
      ownerId: 'owner_dominos',
      name: "Domino's",
      description: 'Cheese-loaded pizzas, garlic sides, and lava cakes.',
      image:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=1200',
      categories: const ['Pizza', 'Desserts'],
      rating: 4.4,
      reviewCount: 780,
      deliveryTime: 30,
      deliveryFee: 180,
      distance: 3.8,
      address: 'Johar Town, Lahore',
      isPopular: true,
      lat: 31.468,
      lng: 74.272,
    ),
    _restaurant(
      id: 'hardees',
      ownerId: 'owner_hardees',
      name: "Hardee's",
      description:
          'Thickburgers, charbroiled chicken, curly fries, and brownies.',
      image:
          'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=1200',
      categories: const ['Burgers', 'Fast Food'],
      rating: 4.5,
      reviewCount: 620,
      deliveryTime: 29,
      deliveryFee: 190,
      distance: 5.1,
      address: 'Packages Mall, Lahore',
      isFeatured: true,
      lat: 31.471,
      lng: 74.354,
    ),
    _restaurant(
      id: 'burger_king',
      ownerId: 'owner_burger_king',
      name: 'Burger King',
      description: 'Whoppers, chicken royales, onion rings, and sundaes.',
      image:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=1200',
      categories: const ['Burgers', 'Fast Food', 'Desserts'],
      rating: 4.3,
      reviewCount: 550,
      deliveryTime: 27,
      deliveryFee: 160,
      distance: 2.9,
      address: 'Liberty Market, Lahore',
      lat: 31.524,
      lng: 74.349,
    ),
    _restaurant(
      id: 'subway',
      ownerId: 'owner_subway',
      name: 'Subway',
      description: 'Fresh subs, salads, cookies, and soft drinks.',
      image: 'https://images.unsplash.com/photo-1553909489-cd47e0907980?w=1200',
      categories: const ['Healthy', 'Fast Food', 'Drinks'],
      rating: 4.4,
      reviewCount: 510,
      deliveryTime: 22,
      deliveryFee: 130,
      distance: 1.8,
      address: 'Liberty Market, Lahore',
      isPopular: true,
      lat: 31.524,
      lng: 74.349,
    ),
    _restaurant(
      id: 'johnny_jugnu',
      ownerId: 'owner_johnny_jugnu',
      name: 'Johnny & Jugnu',
      description: 'Loaded fries, saucy burgers, wings, and shakes.',
      image:
          'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=1200',
      categories: const ['Burgers', 'Fast Food', 'Drinks'],
      rating: 4.8,
      reviewCount: 1540,
      deliveryTime: 35,
      deliveryFee: 220,
      distance: 6.4,
      address: 'Model Town, Lahore',
      isFeatured: true,
      isPopular: true,
      lat: 31.483,
      lng: 74.326,
    ),
    _restaurant(
      id: 'optp',
      ownerId: 'owner_optp',
      name: 'OPTP',
      description: 'Burgers, masala fries, nuggets, and quick comfort food.',
      image:
          'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=1200',
      categories: const ['Burgers', 'Fast Food'],
      rating: 4.2,
      reviewCount: 430,
      deliveryTime: 26,
      deliveryFee: 140,
      distance: 2.6,
      address: 'Main Boulevard, Lahore',
      lat: 31.509,
      lng: 74.345,
    ),
    _restaurant(
      id: 'howdy',
      ownerId: 'owner_howdy',
      name: 'Howdy',
      description: 'Premium burgers, fries, and thick brownie shakes.',
      image: 'https://images.unsplash.com/photo-1550317138-10000687a72b?w=1200',
      categories: const ['Burgers', 'Drinks', 'Desserts'],
      rating: 4.6,
      reviewCount: 690,
      deliveryTime: 31,
      deliveryFee: 210,
      distance: 4.9,
      address: 'Fortress Stadium, Lahore',
      isFeatured: true,
      lat: 31.533,
      lng: 74.366,
    ),
  ];

  static final List<FoodModel> foods = [
    ..._foods('mcdonalds', "McDonald's", 'Burgers', [
      ('Big Mac', 950.0),
      ('McChicken', 750.0),
      ('McArabia', 890.0),
      ('Chicken Nuggets', 550.0),
      ('Fries Large', 350.0),
      ('Coke', 150.0),
      ('McFlurry Oreo', 450.0),
    ]),
    ..._foods('kfc', 'KFC', 'Fast Food', [
      ('Zinger Burger', 790.0),
      ('Mighty Zinger', 1090.0),
      ('Twister Wrap', 680.0),
      ('Hot Wings', 850.0),
      ('Krunch Burger', 320.0),
      ('Fries', 250.0),
      ('Pepsi', 150.0),
    ]),
    ..._foods('pizza_hut', 'Pizza Hut', 'Pizza', [
      ('Chicken Fajita Small', 1099.0),
      ('Chicken Supreme Medium', 1999.0),
      ('Pepperoni Pizza', 2199.0),
      ('Garlic Bread', 399.0),
      ('Pasta Alfredo', 799.0),
      ('Lava Cake', 350.0),
    ]),
    ..._foods('dominos', "Domino's", 'Pizza', [
      ('Chicken Tikka Pizza', 1299.0),
      ('BBQ Pizza', 1499.0),
      ('Cheese Burst Pizza', 1799.0),
      ('Garlic Bread', 399.0),
      ('Choco Lava Cake', 320.0),
    ]),
    ..._foods('hardees', "Hardee's", 'Burgers', [
      ('Famous Star Burger', 1090.0),
      ('Super Star Burger', 1390.0),
      ('Chicken Fillet Burger', 890.0),
      ('Curly Fries', 450.0),
      ('Brownie', 350.0),
    ]),
    ..._foods('burger_king', 'Burger King', 'Burgers', [
      ('Whopper', 1050.0),
      ('Chicken Royale', 850.0),
      ('Beef Burger', 950.0),
      ('Onion Rings', 350.0),
      ('Sundae', 250.0),
    ]),
    ..._foods('subway', 'Subway', 'Healthy', [
      ('Chicken Teriyaki Sub', 850.0),
      ('Turkey Sub', 890.0),
      ('Veggie Delight', 650.0),
      ('Cookies', 120.0),
      ('Soft Drink', 150.0),
    ]),
    ..._foods('johnny_jugnu', 'Johnny & Jugnu', 'Burgers', [
      ('Loaded Fries', 850.0),
      ('Beef Burger', 950.0),
      ('Chicken Burger', 790.0),
      ('Wings', 850.0),
      ('Shake', 450.0),
    ]),
    ..._foods('optp', 'OPTP', 'Fast Food', [
      ('Cheese Burger', 850.0),
      ('Grilled Chicken Burger', 950.0),
      ('Masala Fries', 450.0),
      ('Nuggets', 450.0),
      ('Ice Cream', 250.0),
    ]),
    ..._foods('howdy', 'Howdy', 'Burgers', [
      ('Son of a Bun Burger', 990.0),
      ('Jalapeno Burger', 1050.0),
      ('Beef Burger', 1150.0),
      ('Fries', 350.0),
      ('Brownie Shake', 550.0),
    ]),
  ];

  static final List<CouponModel> coupons = [
    _coupon(
      'WELCOME20',
      20,
      CouponType.percentage,
      '20% off every first order',
      minOrder: 500,
      maxDiscount: 500,
    ),
    _coupon(
      'NEWUSER50',
      50,
      CouponType.percentage,
      '50% off up to Rs.500',
      minOrder: 800,
      maxDiscount: 500,
    ),
    _coupon(
      'FREEDELIVERY',
      0,
      CouponType.freeDelivery,
      'Free delivery',
      minOrder: 1200,
    ),
    _coupon('SAVE100', 100, CouponType.flat, 'Rs.100 off', minOrder: 700),
    _coupon(
      'PIZZA30',
      30,
      CouponType.percentage,
      '30% off pizza orders',
      minOrder: 1000,
      maxDiscount: 700,
    ),
  ];

  static final List<NotificationModel> notifications = [
    _notification(
      'Order accepted',
      'KFC confirmed your Zinger order.',
      NotificationType.orderAccepted,
    ),
    _notification(
      'Weekend special',
      'Buy 1 Get 1 Pizza is live tonight.',
      NotificationType.newOffer,
    ),
    _notification(
      'Coupon unlocked',
      'Use SAVE100 on your next meal.',
      NotificationType.coupon,
    ),
  ];

  static final List<ReviewModel> reviews = [
    _review('mcdonalds', 'Areeba Khan', 4.8, 'Fresh, quick, and well packed.'),
    _review(
      'johnny_jugnu',
      'Bilal Ahmed',
      4.9,
      'Loaded fries were excellent. Delivery was smooth.',
    ),
    _review(
      'pizza_hut',
      'Sara Malik',
      4.5,
      'Great pizza, garlic bread could be warmer.',
    ),
  ];

  static List<BannerModel> get banners => [
    ...BannerModel.defaults,
    const BannerModel(
      id: 'midnight',
      title: 'Midnight Discounts',
      subtitle: 'Order after 10PM',
      colorHex: '1F2937',
    ),
  ];

  static List<FoodModel> foodsForRestaurant(String restaurantId) {
    return foods.where((food) => food.restaurantId == restaurantId).toList();
  }

  static RestaurantModel _restaurant({
    required String id,
    required String ownerId,
    required String name,
    required String description,
    required String image,
    required List<String> categories,
    required double rating,
    required int reviewCount,
    required int deliveryTime,
    required double deliveryFee,
    required double distance,
    required String address,
    required double lat,
    required double lng,
    bool isFeatured = false,
    bool isPopular = false,
  }) {
    return RestaurantModel(
      id: id,
      ownerId: ownerId,
      name: name,
      description: description,
      image: image,
      logo: '',
      categories: categories,
      rating: rating,
      reviewCount: reviewCount,
      deliveryTime: deliveryTime,
      deliveryFee: deliveryFee,
      distance: distance,
      latitude: lat,
      longitude: lng,
      address: address,
      isFeatured: isFeatured,
      isPopular: isPopular,
      createdAt: _now,
    );
  }

  static List<FoodModel> _foods(
    String restaurantId,
    String restaurantName,
    String category,
    List<(String, double)> names,
  ) {
    final imageByCategory = {
      'Pizza':
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=1000',
      'Healthy':
          'https://images.unsplash.com/photo-1628191010210-a59de33e5941?w=1000',
      'Fast Food':
          'https://images.unsplash.com/photo-1562967914-608f82629710?w=1000',
      'Burgers':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=1000',
    };

    return names.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final name = item.$1;
      final price = item.$2;
      final foodCategory = _categoryForName(name, category);
      return FoodModel(
        id: '${restaurantId}_${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'_+$'), '')}',
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        name: name,
        description: _descriptionForFood(name, restaurantName),
        image: imageByCategory[foodCategory] ?? imageByCategory[category]!,
        category: foodCategory,
        price: price,
        oldPrice: index % 3 == 0 ? price + 150 : 0,
        rating: 4.1 + ((index % 5) * 0.1),
        reviewCount: 60 + (index * 37),
        preparationTime: 12 + (index % 5) * 3,
        isAvailable: true,
        isPopular: index < 2,
        customizations: const [
          'Extra Cheese',
          'Extra Sauce',
          'Extra Chicken',
          'Drink Selection',
        ],
        createdAt: _now,
      );
    }).toList();
  }

  static String _categoryForName(String name, String fallback) {
    final lower = name.toLowerCase();
    if (lower.contains('pizza')) return 'Pizza';
    if (lower.contains('cake') ||
        lower.contains('flurry') ||
        lower.contains('brownie') ||
        lower.contains('sundae') ||
        lower.contains('ice cream')) {
      return 'Desserts';
    }
    if (lower.contains('coke') ||
        lower.contains('pepsi') ||
        lower.contains('drink') ||
        lower.contains('shake')) {
      return 'Drinks';
    }
    if (lower.contains('fries') ||
        lower.contains('nuggets') ||
        lower.contains('wings') ||
        lower.contains('bread') ||
        lower.contains('rings')) {
      return 'Fast Food';
    }
    return fallback;
  }

  static String _descriptionForFood(String name, String restaurantName) {
    return '$name from $restaurantName, prepared fresh with bold flavor, quality ingredients, and delivery-friendly packaging.';
  }

  static CouponModel _coupon(
    String code,
    double discount,
    CouponType type,
    String description, {
    double minOrder = 0,
    double maxDiscount = 0,
  }) {
    return CouponModel(
      code: code,
      discount: discount,
      type: type,
      description: description,
      maxDiscount: maxDiscount,
      minOrder: minOrder,
      expiryDate: _now.add(const Duration(days: 365)),
    );
  }

  static NotificationModel _notification(
    String title,
    String body,
    NotificationType type,
  ) {
    return NotificationModel(
      id: title.toLowerCase().replaceAll(' ', '_'),
      title: title,
      body: body,
      type: type,
      userId: 'all',
      createdAt: _now,
    );
  }

  static ReviewModel _review(
    String restaurantId,
    String userName,
    double rating,
    String comment,
  ) {
    return ReviewModel(
      id: '${restaurantId}_${userName.hashCode.abs()}',
      userId: 'demo_user',
      userName: userName,
      restaurantId: restaurantId,
      rating: rating,
      comment: comment,
      createdAt: _now,
    );
  }

  static List<String> get categories => AppConstants.foodCategories;
}
