import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_helpers.dart';

enum NotificationType {
  orderAccepted,
  foodPreparing,
  riderAssigned,
  delivered,
  newOffer,
  coupon,
  general,
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final String? userId;
  final String? orderId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.userId,
    this.orderId,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      body: (map['body'] ?? '').toString(),
      type: NotificationType.values.firstWhere(
        (type) => type.name == map['type'],
        orElse: () => NotificationType.general,
      ),
      userId: map['userId']?.toString(),
      orderId: map['orderId']?.toString(),
      isRead: map['isRead'] as bool? ?? false,
      createdAt: dateTimeFromValue(map['createdAt']),
    );
  }

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    return NotificationModel.fromMap({
      ...mapFromValue(doc.data()),
      'id': doc.id,
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.name,
      'userId': userId,
      'orderId': orderId,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  IconDataKey get iconKey {
    return switch (type) {
      NotificationType.orderAccepted => IconDataKey.check,
      NotificationType.foodPreparing => IconDataKey.restaurant,
      NotificationType.riderAssigned => IconDataKey.delivery,
      NotificationType.delivered => IconDataKey.done,
      NotificationType.newOffer => IconDataKey.offer,
      NotificationType.coupon => IconDataKey.coupon,
      NotificationType.general => IconDataKey.bell,
    };
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      type: type,
      userId: userId,
      orderId: orderId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}

enum IconDataKey { check, restaurant, delivery, done, offer, coupon, bell }
