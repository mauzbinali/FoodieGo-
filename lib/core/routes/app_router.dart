import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/auth/screens/splash_screen.dart';
import '../../presentation/auth/screens/onboarding_screen.dart';
import '../../presentation/auth/screens/role_selection_screen.dart';
import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/auth/screens/register_screen.dart';
import '../../presentation/auth/screens/forgot_password_screen.dart';
import '../../presentation/auth/screens/email_verification_screen.dart';

import '../../presentation/home/screens/home_screen.dart';
import '../../presentation/restaurant/screens/restaurant_list_screen.dart';
import '../../presentation/restaurant/screens/restaurant_detail_screen.dart';
import '../../presentation/food/screens/food_detail_screen.dart';
import '../../presentation/home/screens/search_screen.dart';

import '../../presentation/cart/screens/cart_screen.dart';
import '../../presentation/order/screens/checkout_screen.dart';
import '../../presentation/order/screens/order_success_screen.dart';
import '../../presentation/order/screens/orders_screen.dart';
import '../../presentation/order/screens/order_detail_screen.dart';
import '../../presentation/order/screens/order_tracking_screen.dart';

import '../../presentation/address/screens/address_screen.dart';
import '../../presentation/address/screens/add_address_screen.dart';

import '../../presentation/profile/screens/profile_screen.dart';
import '../../presentation/profile/screens/edit_profile_screen.dart';

import '../../presentation/favorites/screens/favorites_screen.dart';
import '../../presentation/reviews/screens/reviews_screen.dart';
import '../../presentation/reviews/screens/add_review_screen.dart';
import '../../presentation/notifications/screens/notifications_screen.dart';
import '../../presentation/profile/screens/settings_screen.dart';

import '../../presentation/owner/screens/owner_dashboard_screen.dart';
import '../../presentation/owner/screens/owner_menu_screen.dart';
import '../../presentation/owner/screens/owner_add_food_screen.dart';
import '../../presentation/owner/screens/owner_orders_screen.dart';
import '../../presentation/owner/screens/owner_reviews_screen.dart';

import '../../presentation/admin/screens/admin_dashboard_screen.dart';
import '../../presentation/admin/screens/admin_users_screen.dart';
import '../../presentation/admin/screens/admin_restaurants_screen.dart';
import '../../presentation/admin/screens/admin_add_restaurant_screen.dart';
import '../../presentation/admin/screens/admin_foods_screen.dart';
import '../../presentation/admin/screens/admin_add_food_screen.dart';
import '../../presentation/admin/screens/admin_orders_screen.dart';
import '../../presentation/admin/screens/admin_coupons_screen.dart';
import '../../presentation/admin/screens/admin_notifications_screen.dart';

import '../providers/theme_provider.dart';
import '../constants/app_constants.dart';
import '../storage/storage_keys.dart';
import 'app_routes.dart';
import 'main_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return _createRouter(prefs);
});

GoRouter _createRouter(SharedPreferences prefs) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = prefs.getBool(AppConstants.isLoggedInKey) ?? false;
      final isOnboardingDone =
          prefs.getBool(AppConstants.isOnboardingDoneKey) ?? false;
      final location = state.uri.path;

      final authRoutes = [
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.forgotPassword,
        AppRoutes.emailVerification,
        AppRoutes.onboarding,
        AppRoutes.roleSelection,
        AppRoutes.splash,
      ];

      final isAuthRoute = authRoutes.contains(location);

      if (location == AppRoutes.splash) return null;

      if (!isOnboardingDone && location != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }

      if (location == AppRoutes.roleSelection) return null;

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.roleSelection;
      }

      if (isLoggedIn &&
          isAuthRoute &&
          location != AppRoutes.splash &&
          location != AppRoutes.roleSelection) {
        return _entryRouteForRole(prefs.getString(StorageKeys.userRole));
      }

      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) =>
            _fadeTransitionPage(state: state, child: const OnboardingScreen()),
      ),

      // Role Selection
      GoRoute(
        path: AppRoutes.roleSelection,
        name: 'roleSelection',
        pageBuilder: (context, state) => _fadeTransitionPage(
          state: state,
          child: const RoleSelectionScreen(),
        ),
      ),

      // Login
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) =>
            _slideTransitionPage(state: state, child: const LoginScreen()),
      ),

      // Register
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        pageBuilder: (context, state) =>
            _slideTransitionPage(state: state, child: const RegisterScreen()),
      ),

      // Forgot Password
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const ForgotPasswordScreen(),
        ),
      ),

      // Email Verification
      GoRoute(
        path: AppRoutes.emailVerification,
        name: 'emailVerification',
        builder: (context, state) => const EmailVerificationScreen(),
      ),

      // Main Shell (Bottom Navigation)
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.main,
            redirect: (context, state) => AppRoutes.home,
          ),
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.favorites,
            name: 'favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: AppRoutes.orders,
            name: 'orders',
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Restaurant List
      GoRoute(
        path: AppRoutes.restaurantList,
        name: 'restaurantList',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: RestaurantListScreen(
            category: state.uri.queryParameters['category'],
            title: state.uri.queryParameters['title'],
          ),
        ),
      ),

      // Restaurant Detail
      GoRoute(
        path: AppRoutes.restaurantDetail,
        name: 'restaurantDetail',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: RestaurantDetailScreen(
            restaurantId: state.pathParameters['id']!,
          ),
        ),
      ),

      // Food Detail
      GoRoute(
        path: AppRoutes.foodDetail,
        name: 'foodDetail',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: FoodDetailScreen(foodId: state.pathParameters['id']!),
        ),
      ),

      // Search
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        pageBuilder: (context, state) =>
            _fadeTransitionPage(state: state, child: const SearchScreen()),
      ),

      // Cart
      GoRoute(
        path: AppRoutes.cart,
        name: 'cart',
        pageBuilder: (context, state) =>
            _slideTransitionPage(state: state, child: const CartScreen()),
      ),

      // Checkout
      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        pageBuilder: (context, state) =>
            _slideTransitionPage(state: state, child: const CheckoutScreen()),
      ),

      // Order Success
      GoRoute(
        path: AppRoutes.orderSuccess,
        name: 'orderSuccess',
        pageBuilder: (context, state) => _fadeTransitionPage(
          state: state,
          child: OrderSuccessScreen(
            orderId: state.uri.queryParameters['orderId'] ?? '',
          ),
        ),
      ),

      // Order Detail
      GoRoute(
        path: AppRoutes.orderDetail,
        name: 'orderDetail',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: OrderDetailScreen(orderId: state.pathParameters['id']!),
        ),
      ),

      // Order Tracking
      GoRoute(
        path: AppRoutes.orderTracking,
        name: 'orderTracking',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: OrderTrackingScreen(orderId: state.pathParameters['id']!),
        ),
      ),

      // Addresses
      GoRoute(
        path: AppRoutes.addresses,
        name: 'addresses',
        pageBuilder: (context, state) =>
            _slideTransitionPage(state: state, child: const AddressScreen()),
      ),

      // Add Address
      GoRoute(
        path: AppRoutes.addAddress,
        name: 'addAddress',
        pageBuilder: (context, state) =>
            _slideTransitionPage(state: state, child: const AddAddressScreen()),
      ),

      // Edit Address
      GoRoute(
        path: AppRoutes.editAddress,
        name: 'editAddress',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: AddAddressScreen(addressId: state.pathParameters['id']),
        ),
      ),

      // Edit Profile
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const EditProfileScreen(),
        ),
      ),

      // Reviews
      GoRoute(
        path: AppRoutes.reviews,
        name: 'reviews',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: ReviewsScreen(restaurantId: state.pathParameters['id']!),
        ),
      ),

      // Add Review
      GoRoute(
        path: AppRoutes.addReview,
        name: 'addReview',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: AddReviewScreen(
            restaurantId: state.uri.queryParameters['restaurantId'] ?? '',
            orderId: state.uri.queryParameters['orderId'] ?? '',
          ),
        ),
      ),

      // Notifications
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const NotificationsScreen(),
        ),
      ),

      // Settings
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        pageBuilder: (context, state) =>
            _slideTransitionPage(state: state, child: const SettingsScreen()),
      ),

      // ── Owner Panel ──────────────────────────────
      GoRoute(
        path: AppRoutes.ownerDashboard,
        name: 'ownerDashboard',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const OwnerDashboardScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.ownerMenuManagement,
        name: 'ownerMenu',
        pageBuilder: (context, state) =>
            _slideTransitionPage(state: state, child: const OwnerMenuScreen()),
      ),
      GoRoute(
        path: AppRoutes.ownerAddFood,
        name: 'ownerAddFood',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const OwnerAddFoodScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.ownerEditFood,
        name: 'ownerEditFood',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: OwnerAddFoodScreen(foodId: state.pathParameters['id']),
        ),
      ),
      GoRoute(
        path: AppRoutes.ownerOrders,
        name: 'ownerOrders',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const OwnerOrdersScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.ownerReviews,
        name: 'ownerReviews',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const OwnerReviewsScreen(),
        ),
      ),

      // ── Admin Panel ──────────────────────────────
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: 'adminDashboard',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const AdminDashboardScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminUsers,
        name: 'adminUsers',
        pageBuilder: (context, state) =>
            _slideTransitionPage(state: state, child: const AdminUsersScreen()),
      ),
      GoRoute(
        path: AppRoutes.adminRestaurants,
        name: 'adminRestaurants',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const AdminRestaurantsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminAddRestaurant,
        name: 'adminAddRestaurant',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const AdminAddRestaurantScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminFoods,
        name: 'adminFoods',
        pageBuilder: (context, state) =>
            _slideTransitionPage(state: state, child: const AdminFoodsScreen()),
      ),
      GoRoute(
        path: AppRoutes.adminAddFood,
        name: 'adminAddFood',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const AdminAddFoodScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminOrders,
        name: 'adminOrders',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const AdminOrdersScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminCoupons,
        name: 'adminCoupons',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const AdminCouponsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminNotifications,
        name: 'adminNotifications',
        pageBuilder: (context, state) => _slideTransitionPage(
          state: state,
          child: const AdminNotificationsScreen(),
        ),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.splash),
              child: const Text('Restart'),
            ),
          ],
        ),
      ),
    ),
  );
}

String _entryRouteForRole(String? role) {
  return switch (role) {
    AppConstants.roleAdmin => AppRoutes.adminDashboard,
    AppConstants.roleOwner => AppRoutes.ownerDashboard,
    _ => AppRoutes.main,
  };
}

CustomTransitionPage<void> _slideTransitionPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeOutCubic;
      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

CustomTransitionPage<void> _fadeTransitionPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
