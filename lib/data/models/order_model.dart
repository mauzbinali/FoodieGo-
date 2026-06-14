import 'package:cloud_firestore/cloud_firestore.dart';

import 'address_model.dart';
import 'cart_item_model.dart';
import 'model_helpers.dart';

class RiderInfo {
  final String name;
  final String phone;
  final String? image;
  final double? latitude;
  final double? longitude;

  const RiderInfo({
    required this.name,
    required this.phone,
    this.image,
    this.latitude,
    this.longitude,
  });

  factory RiderInfo.fromMap(Map<String, dynamic> map) {
    return RiderInfo(
      name: (map['name'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      image: map['image']?.toString(),
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class OrderModel {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImage;
  final List<CartItemModel> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double discount;
  final double tip;
  final double totalPrice;
  final String status;
  final AddressModel deliveryAddress;
  final String paymentMethod;
  final String? couponCode;
  final String? orderNotes;
  final String? deliveryInstructions;
  final RiderInfo? rider;
  final int estimatedDeliveryMinutes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deliveredAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.discount,
    required this.tip,
    required this.totalPrice,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.couponCode,
    this.orderNotes,
    this.deliveryInstructions,
    this.rider,
    this.estimatedDeliveryMinutes = 30,
    required this.createdAt,
    this.updatedAt,
    this.deliveredAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: (map['id'] ?? '').toString(),
      userId: (map['userId'] ?? '').toString(),
      restaurantId: (map['restaurantId'] ?? '').toString(),
      restaurantName: (map['restaurantName'] ?? '').toString(),
      restaurantImage: (map['restaurantImage'] ?? '').toString(),
      items: (map['items'] as List? ?? [])
          .map((item) => CartItemModel.fromMap(mapFromValue(item)))
          .toList(),
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0,
      tax: (map['tax'] as num?)?.toDouble() ?? 0,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0,
      tip: (map['tip'] as num?)?.toDouble() ?? 0,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0,
      status: (map['status'] ?? 'Order Placed').toString(),
      deliveryAddress: AddressModel.fromMap(
        mapFromValue(map['deliveryAddress']),
      ),
      paymentMethod: (map['paymentMethod'] ?? 'Cash On Delivery').toString(),
      couponCode: map['couponCode']?.toString(),
      orderNotes: map['orderNotes']?.toString(),
      deliveryInstructions: map['deliveryInstructions']?.toString(),
      rider: map['rider'] == null
          ? null
          : RiderInfo.fromMap(mapFromValue(map['rider'])),
      estimatedDeliveryMinutes:
          (map['estimatedDeliveryMinutes'] as num?)?.toInt() ?? 30,
      createdAt: dateTimeFromValue(map['createdAt']),
      updatedAt: map['updatedAt'] == null
          ? null
          : dateTimeFromValue(map['updatedAt']),
      deliveredAt: map['deliveredAt'] == null
          ? null
          : dateTimeFromValue(map['deliveredAt']),
    );
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    return OrderModel.fromMap({...mapFromValue(doc.data()), 'id': doc.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'restaurantImage': restaurantImage,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'tip': tip,
      'totalPrice': totalPrice,
      'status': status,
      'deliveryAddress': deliveryAddress.toMap(),
      'paymentMethod': paymentMethod,
      'couponCode': couponCode,
      'orderNotes': orderNotes,
      'deliveryInstructions': deliveryInstructions,
      'rider': rider?.toMap(),
      'estimatedDeliveryMinutes': estimatedDeliveryMinutes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
      'deliveredAt': deliveredAt == null
          ? null
          : Timestamp.fromDate(deliveredAt!),
    };
  }

  bool get isActive => status != 'Delivered' && status != 'Cancelled';
  bool get isDelivered => status == 'Delivered';
  bool get isCancelled => status == 'Cancelled';
  bool get canCancel => status == 'Order Placed';
  int get totalItems => items.fold(0, (total, item) => total + item.quantity);

  OrderModel copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    String? restaurantImage,
    List<CartItemModel>? items,
    double? subtotal,
    double? tax,
    double? deliveryFee,
    double? discount,
    double? tip,
    double? totalPrice,
    String? status,
    AddressModel? deliveryAddress,
    String? paymentMethod,
    String? couponCode,
    String? orderNotes,
    String? deliveryInstructions,
    RiderInfo? rider,
    int? estimatedDeliveryMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deliveredAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantImage: restaurantImage ?? this.restaurantImage,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      tip: tip ?? this.tip,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      couponCode: couponCode ?? this.couponCode,
      orderNotes: orderNotes ?? this.orderNotes,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      rider: rider ?? this.rider,
      estimatedDeliveryMinutes:
          estimatedDeliveryMinutes ?? this.estimatedDeliveryMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }
}
