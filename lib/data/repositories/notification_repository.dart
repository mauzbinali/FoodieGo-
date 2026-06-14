import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/notification_model.dart';
import 'demo_data.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

class NotificationRepository {
  static final List<NotificationModel> _notifications = [
    ...DemoData.notifications,
  ];
  final Uuid _uuid = const Uuid();

  Stream<List<NotificationModel>> getUserNotificationsStream(String userId) {
    return Stream.value(
      _notifications
          .where((item) => item.userId == userId || item.userId == 'all')
          .toList(),
    );
  }

  Stream<int> getUnreadCountStream(String userId) {
    return getUserNotificationsStream(
      userId,
    ).map((items) => items.where((item) => !item.isRead).length);
  }

  Stream<List<NotificationModel>> getAllNotificationsStream() {
    return Stream.value(_notifications);
  }

  Future<NotificationModel> sendNotification({
    required String title,
    required String body,
    required NotificationType type,
    String? userId,
    String? orderId,
  }) async {
    final notification = NotificationModel(
      id: _uuid.v4(),
      title: title,
      body: body,
      type: type,
      userId: userId ?? 'all',
      orderId: orderId,
      createdAt: DateTime.now(),
    );
    _notifications.insert(0, notification);
    return notification;
  }

  Future<void> sendOrderNotification({
    required String userId,
    required String orderId,
    required String status,
  }) {
    return sendNotification(
      title: 'Order Update',
      body: 'Your order is now $status.',
      type: NotificationType.orderAccepted,
      userId: userId,
      orderId: orderId,
    );
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((item) => item.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  Future<void> markAllAsRead(String userId) async {
    for (var i = 0; i < _notifications.length; i++) {
      final item = _notifications[i];
      if (item.userId == userId || item.userId == 'all') {
        _notifications[i] = item.copyWith(isRead: true);
      }
    }
  }

  Future<void> deleteNotification(String id) async {
    _notifications.removeWhere((item) => item.id == id);
  }
}
