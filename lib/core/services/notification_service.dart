import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background FCM message: ${message.messageId}');
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'foodiego_channel',
    'FoodieGo Notifications',
    description: 'Notifications for orders, offers, and account updates',
    importance: Importance.high,
  );

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    if (Firebase.apps.isNotEmpty) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    }

    _initialized = true;
  }

  Future<String?> getFcmToken() async {
    if (Firebase.apps.isEmpty) return null;
    return FirebaseMessaging.instance.getToken();
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'foodiego_channel',
      'FoodieGo Notifications',
      channelDescription:
          'Notifications for orders, offers, and account updates',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload,
    );
  }

  Future<void> showOrderNotification({
    required String orderId,
    required String status,
  }) {
    final body = switch (status) {
      'Order Confirmed' => 'Your order has been confirmed.',
      'Preparing Food' => 'The restaurant is preparing your food.',
      'Rider Assigned' => 'A rider has been assigned to your order.',
      'Out For Delivery' => 'Your order is on the way.',
      'Delivered' => 'Order delivered. Enjoy your meal!',
      _ => 'Your order status has been updated.',
    };

    return showLocalNotification(
      title: 'FoodieGo Order Update',
      body: body,
      payload: orderId,
    );
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    showLocalNotification(
      title: notification.title ?? 'FoodieGo',
      body: notification.body ?? '',
      payload: message.data['orderId']?.toString(),
    );
  }
}
