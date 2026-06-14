class AppConstants {
  AppConstants._();

  static const String appName = 'FoodieGo';
  static const String appVersion = '1.0.0';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String restaurantsCollection = 'restaurants';
  static const String foodsCollection = 'foods';
  static const String ordersCollection = 'orders';
  static const String reviewsCollection = 'reviews';
  static const String couponsCollection = 'coupons';
  static const String notificationsCollection = 'notifications';
  static const String bannersCollection = 'banners';

  // Hive Boxes
  static const String userBox = 'userBox';
  static const String restaurantBox = 'restaurantBox';
  static const String cartBox = 'cartBox';
  static const String settingsBox = 'settingsBox';

  // SharedPreferences Keys
  static const String isLoggedInKey = 'is_logged_in';
  static const String userIdKey = 'user_id';
  static const String isOnboardingDoneKey = 'is_onboarding_done';
  static const String rememberLoginKey = 'remember_login';
  static const String savedEmailKey = 'saved_email';
  static const String savedPasswordKey = 'saved_password';

  // Delivery
  static const double defaultDeliveryFee = 150.0;
  static const double freeDeliveryThreshold = 2000.0;
  static const double taxRate = 0.05;

  // Map
  static const double defaultLatitude = 31.5204;
  static const double defaultLongitude = 74.3587;
  static const double defaultZoom = 14.0;

  // Pagination
  static const int pageSize = 10;

  // Image
  static const double maxImageSizeMB = 5.0;

  // Order Status
  static const String orderPlaced = 'Order Placed';
  static const String orderConfirmed = 'Order Confirmed';
  static const String preparingFood = 'Preparing Food';
  static const String readyForPickup = 'Ready For Pickup';
  static const String riderAssigned = 'Rider Assigned';
  static const String outForDelivery = 'Out For Delivery';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';

  // Payment Methods
  static const String cashOnDelivery = 'Cash On Delivery';
  static const String creditCard = 'Credit Card';
  static const String easyPaisa = 'EasyPaisa';
  static const String jazzCash = 'JazzCash';

  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleOwner = 'owner';
  static const String roleAdmin = 'admin';

  // Categories
  static const List<String> foodCategories = [
    'Burgers',
    'Pizza',
    'BBQ',
    'Fast Food',
    'Chinese',
    'Desserts',
    'Drinks',
    'Healthy',
  ];

  // Coupons
  static const List<Map<String, dynamic>> defaultCoupons = [
    {
      'code': 'WELCOME20',
      'discount': 20.0,
      'type': 'percentage',
      'description': '20% Off',
    },
    {
      'code': 'NEWUSER50',
      'discount': 50.0,
      'type': 'percentage',
      'maxDiscount': 500.0,
      'description': '50% Off Up To Rs.500',
    },
    {
      'code': 'FREEDELIVERY',
      'discount': 0.0,
      'type': 'freeDelivery',
      'description': 'Free Delivery',
    },
    {
      'code': 'SAVE100',
      'discount': 100.0,
      'type': 'flat',
      'description': 'Rs.100 Off',
    },
    {
      'code': 'PIZZA30',
      'discount': 30.0,
      'type': 'percentage',
      'description': '30% Off Pizza',
    },
  ];

  // Banners
  static const List<Map<String, String>> banners = [
    {
      'title': '50% Off First Order',
      'subtitle': 'Use code WELCOME20',
      'color': 'FF6B35',
    },
    {
      'title': 'Free Delivery Above Rs.2000',
      'subtitle': 'No code needed',
      'color': '2EC4B6',
    },
    {
      'title': 'Weekend Special',
      'subtitle': 'Every Saturday & Sunday',
      'color': 'E71D36',
    },
    {
      'title': 'Buy 1 Get 1 Pizza',
      'subtitle': 'At Pizza Hut & Dominos',
      'color': '662E9B',
    },
    {
      'title': 'Midnight Discounts',
      'subtitle': 'Order after 10PM',
      'color': 'F46036',
    },
  ];
}
