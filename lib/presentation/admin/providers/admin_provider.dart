import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/order_repository.dart';
import 'demo_management_provider.dart';

class AdminStats {
  final int totalUsers;
  final int totalOrders;
  final int totalRestaurants;
  final double totalRevenue;
  final int todayOrders;
  final double todayRevenue;

  const AdminStats({
    this.totalUsers = 0,
    this.totalOrders = 0,
    this.totalRestaurants = 0,
    this.totalRevenue = 0,
    this.todayOrders = 0,
    this.todayRevenue = 0,
  });
}

final adminStatsProvider = FutureProvider<AdminStats>((ref) async {
  final managed = ref.watch(demoManagementProvider);
  final orders = await ref
      .watch(orderRepositoryProvider)
      .getAllOrders(limit: 500);
  if (Firebase.apps.isEmpty) {
    return _buildStats(
      orders: orders,
      users: 12,
      restaurants: managed.restaurants.length,
    );
  }

  final firestore = FirebaseFirestore.instance;
  final usersSnap = await firestore
      .collection(AppConstants.usersCollection)
      .count()
      .get();
  final restaurantsSnap = await firestore
      .collection(AppConstants.restaurantsCollection)
      .count()
      .get();
  return _buildStats(
    orders: orders,
    users: usersSnap.count ?? 0,
    restaurants: restaurantsSnap.count ?? 0,
  );
});

AdminStats _buildStats({
  required List<OrderModel> orders,
  required int users,
  required int restaurants,
}) {
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final delivered = orders.where((order) => order.isDelivered);
  final todayOrders = orders
      .where((order) => order.createdAt.isAfter(startOfDay))
      .toList();
  return AdminStats(
    totalUsers: users,
    totalOrders: orders.length,
    totalRestaurants: restaurants,
    totalRevenue: delivered.fold(0, (total, order) => total + order.totalPrice),
    todayOrders: todayOrders.length,
    todayRevenue: todayOrders
        .where((order) => order.isDelivered)
        .fold(0, (total, order) => total + order.totalPrice),
  );
}

final adminUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  if (Firebase.apps.isEmpty) {
    return [
      UserModel(
        uid: 'demo_admin',
        name: 'Admin User',
        email: 'admin@foodiego.local',
        phone: '',
        role: AppConstants.roleAdmin,
        createdAt: DateTime.now(),
      ),
    ];
  }
  final snapshot = await FirebaseFirestore.instance
      .collection(AppConstants.usersCollection)
      .orderBy('createdAt', descending: true)
      .get();
  return snapshot.docs.map(UserModel.fromFirestore).toList();
});

class AdminUserNotifier extends StateNotifier<bool> {
  AdminUserNotifier() : super(false);

  Future<void> toggleUserStatus(String uid, bool isActive) async {
    if (Firebase.apps.isEmpty) return;
    await FirebaseFirestore.instance
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .update({'isActive': isActive});
  }
}

final adminUserActionsProvider = StateNotifierProvider<AdminUserNotifier, bool>(
  (ref) {
    return AdminUserNotifier();
  },
);
