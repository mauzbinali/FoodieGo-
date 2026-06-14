import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../models/address_model.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(
    Firebase.apps.isEmpty ? null : FirebaseFirestore.instance,
  );
});

class OrderRepository {
  final FirebaseFirestore? _firestore;
  final Uuid _uuid = const Uuid();
  static final List<OrderModel> _demoOrders = [];

  OrderRepository(this._firestore);

  CollectionReference<Map<String, dynamic>>? get _collection =>
      _firestore?.collection(AppConstants.ordersCollection);

  Future<OrderModel> placeOrder({
    required String userId,
    required String restaurantId,
    required String restaurantName,
    required String restaurantImage,
    required List<CartItemModel> cartItems,
    required double subtotal,
    required double tax,
    required double deliveryFee,
    required double discount,
    required double tip,
    required double totalPrice,
    required AddressModel deliveryAddress,
    required String paymentMethod,
    String? couponCode,
    String? orderNotes,
    String? deliveryInstructions,
  }) async {
    final order = OrderModel(
      id: _uuid.v4(),
      userId: userId,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      restaurantImage: restaurantImage,
      items: cartItems,
      subtotal: subtotal,
      tax: tax,
      deliveryFee: deliveryFee,
      discount: discount,
      tip: tip,
      totalPrice: totalPrice,
      status: AppConstants.orderPlaced,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      couponCode: couponCode,
      orderNotes: orderNotes,
      deliveryInstructions: deliveryInstructions,
      estimatedDeliveryMinutes: 35,
      createdAt: DateTime.now(),
    );
    if (_collection == null) {
      _demoOrders.insert(0, order);
      return order;
    }
    await _collection!.doc(order.id).set(order.toMap());
    return order;
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    if (_collection == null) {
      return _demoOrders.where((order) => order.id == orderId).firstOrNull;
    }
    final doc = await _collection!.doc(orderId).get();
    return doc.exists ? OrderModel.fromFirestore(doc) : null;
  }

  Stream<OrderModel?> getOrderStream(String orderId) {
    if (_collection == null) {
      return Stream.value(
        _demoOrders.where((order) => order.id == orderId).firstOrNull,
      );
    }
    return _collection!
        .doc(orderId)
        .snapshots()
        .map((doc) => doc.exists ? OrderModel.fromFirestore(doc) : null);
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    if (_collection == null) {
      return _demoOrders.where((order) => order.userId == userId).toList();
    }
    final snapshot = await _collection!
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map(OrderModel.fromFirestore).toList();
  }

  Stream<List<OrderModel>> getUserOrdersStream(String userId) {
    if (_collection == null) {
      return Stream.value(
        _demoOrders.where((order) => order.userId == userId).toList(),
      );
    }
    return _collection!
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(OrderModel.fromFirestore).toList());
  }

  Stream<List<OrderModel>> getActiveOrdersStream(String userId) {
    return getUserOrdersStream(
      userId,
    ).map((orders) => orders.where((order) => order.isActive).toList());
  }

  Future<List<OrderModel>> getRestaurantOrders(String restaurantId) async {
    if (_collection == null) {
      return _demoOrders
          .where((order) => order.restaurantId == restaurantId)
          .toList();
    }
    final snapshot = await _collection!
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map(OrderModel.fromFirestore).toList();
  }

  Stream<List<OrderModel>> getRestaurantOrdersStream(String restaurantId) {
    if (_collection == null) {
      return Stream.value(
        _demoOrders
            .where((order) => order.restaurantId == restaurantId)
            .toList(),
      );
    }
    return _collection!
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(OrderModel.fromFirestore).toList());
  }

  Future<List<OrderModel>> getAllOrders({int limit = 100}) async {
    if (_collection == null) return _demoOrders.take(limit).toList();
    final snapshot = await _collection!
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map(OrderModel.fromFirestore).toList();
  }

  Stream<List<OrderModel>> getAllOrdersStream() {
    if (_collection == null) return Stream.value(_demoOrders);
    return _collection!
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(OrderModel.fromFirestore).toList());
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    if (_collection == null) {
      final index = _demoOrders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _demoOrders[index] = _demoOrders[index].copyWith(
          status: status,
          updatedAt: DateTime.now(),
        );
      }
      return;
    }
    await _collection!.doc(orderId).update({
      'status': status,
      'updatedAt': Timestamp.now(),
      if (status == AppConstants.delivered) 'deliveredAt': Timestamp.now(),
    });
  }

  Future<void> cancelOrder(String orderId) =>
      updateOrderStatus(orderId, AppConstants.cancelled);
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
