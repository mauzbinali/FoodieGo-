class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/email-verification';

  // Main Shell
  static const String main = '/main';

  // Home
  static const String home = '/home';

  // Restaurant
  static const String restaurantList = '/restaurants';
  static const String restaurantDetail = '/restaurant/:id';
  static const String restaurantDetailPath = '/restaurant';

  // Food
  static const String foodDetail = '/food/:id';
  static const String foodDetailPath = '/food';

  // Search
  static const String search = '/search';

  // Cart
  static const String cart = '/cart';

  // Checkout
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';

  // Orders
  static const String orders = '/orders';
  static const String orderDetail = '/order/:id';
  static const String orderDetailPath = '/order';
  static const String orderTracking = '/order-tracking/:id';
  static const String orderTrackingPath = '/order-tracking';

  // Address
  static const String addresses = '/addresses';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address/:id';
  static const String editAddressPath = '/edit-address';

  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';

  // Favorites
  static const String favorites = '/favorites';

  // Reviews
  static const String reviews = '/reviews/:id';
  static const String reviewsPath = '/reviews';
  static const String addReview = '/add-review';

  // Notifications
  static const String notifications = '/notifications';

  // Settings
  static const String settings = '/settings';

  // Restaurant Owner
  static const String ownerDashboard = '/owner/dashboard';
  static const String ownerMenuManagement = '/owner/menu';
  static const String ownerAddFood = '/owner/add-food';
  static const String ownerEditFood = '/owner/edit-food/:id';
  static const String ownerEditFoodPath = '/owner/edit-food';
  static const String ownerOrders = '/owner/orders';
  static const String ownerReviews = '/owner/reviews';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminRestaurants = '/admin/restaurants';
  static const String adminAddRestaurant = '/admin/restaurants/add';
  static const String adminFoods = '/admin/foods';
  static const String adminAddFood = '/admin/foods/add';
  static const String adminOrders = '/admin/orders';
  static const String adminCoupons = '/admin/coupons';
  static const String adminNotifications = '/admin/notifications';
}
