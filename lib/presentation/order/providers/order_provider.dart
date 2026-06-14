import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/notification_service.dart';
import '../../../data/models/address_model.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/repositories/order_repository.dart';

class OrderState {
  final bool isLoading;
  final String? errorMessage;
  final String? successOrderId;

  const OrderState({
    this.isLoading = false,
    this.errorMessage,
    this.successOrderId,
  });

  OrderState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successOrderId,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successOrderId: clearSuccess
          ? null
          : successOrderId ?? this.successOrderId,
    );
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository _orderRepo;
  final NotificationRepository _notificationRepo;

  OrderNotifier({
    required OrderRepository orderRepo,
    required NotificationRepository notificationRepo,
  }) : _orderRepo = orderRepo,
       _notificationRepo = notificationRepo,
       super(const OrderState());

  Future<String?> placeOrder({
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
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final order = await _orderRepo.placeOrder(
        userId: userId,
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        restaurantImage: restaurantImage,
        cartItems: cartItems,
        subtotal: subtotal,
        tax: tax,
        deliveryFee: deliveryFee,
        discount: discount,
        tip: tip,
        totalPrice: totalPrice,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        couponCode: couponCode,
        orderNotes: orderNotes,
        deliveryInstructions: deliveryInstructions,
      );
      await _notificationRepo.sendOrderNotification(
        userId: userId,
        orderId: order.id,
        status: order.status,
      );
      await NotificationService.instance.showOrderNotification(
        orderId: order.id,
        status: order.status,
      );
      state = state.copyWith(isLoading: false, successOrderId: order.id);
      return order.id;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return null;
    }
  }

  Future<void> updateOrderStatus(String orderId, String status, String userId) {
    return _orderRepo.updateOrderStatus(orderId, status);
  }

  Future<void> cancelOrder(String orderId) => _orderRepo.cancelOrder(orderId);

  void clearSuccess() => state = state.copyWith(clearSuccess: true);
  void clearError() => state = state.copyWith(clearError: true);
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(
    orderRepo: ref.watch(orderRepositoryProvider),
    notificationRepo: ref.watch(notificationRepositoryProvider),
  );
});

final userOrdersStreamProvider =
    StreamProvider.family<List<OrderModel>, String>((ref, userId) {
      return ref.watch(orderRepositoryProvider).getUserOrdersStream(userId);
    });

final activeOrdersStreamProvider =
    StreamProvider.family<List<OrderModel>, String>((ref, userId) {
      return ref.watch(orderRepositoryProvider).getActiveOrdersStream(userId);
    });

final orderStreamProvider = StreamProvider.family<OrderModel?, String>((
  ref,
  orderId,
) {
  return ref.watch(orderRepositoryProvider).getOrderStream(orderId);
});

final orderByIdProvider = FutureProvider.family<OrderModel?, String>((ref, id) {
  return ref.watch(orderRepositoryProvider).getOrderById(id);
});

final restaurantOrdersStreamProvider =
    StreamProvider.family<List<OrderModel>, String>((ref, restaurantId) {
      return ref
          .watch(orderRepositoryProvider)
          .getRestaurantOrdersStream(restaurantId);
    });

final allOrdersStreamProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.watch(orderRepositoryProvider).getAllOrdersStream();
});
