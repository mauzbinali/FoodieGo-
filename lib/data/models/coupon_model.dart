import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_helpers.dart';

enum CouponType { percentage, flat, freeDelivery }

class CouponModel {
  final String code;
  final double discount;
  final CouponType type;
  final String description;
  final double maxDiscount;
  final double minOrder;
  final bool isActive;
  final DateTime expiryDate;

  const CouponModel({
    required this.code,
    required this.discount,
    required this.type,
    required this.description,
    this.maxDiscount = 0,
    this.minOrder = 0,
    this.isActive = true,
    required this.expiryDate,
  });

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      code: (map['code'] ?? '').toString(),
      discount: (map['discount'] as num?)?.toDouble() ?? 0,
      type: CouponType.values.firstWhere(
        (type) => type.name == map['type'],
        orElse: () => CouponType.flat,
      ),
      description: (map['description'] ?? '').toString(),
      maxDiscount: (map['maxDiscount'] as num?)?.toDouble() ?? 0,
      minOrder: (map['minOrder'] as num?)?.toDouble() ?? 0,
      isActive: map['isActive'] as bool? ?? true,
      expiryDate: dateTimeFromValue(
        map['expiryDate'],
        fallback: DateTime.now().add(const Duration(days: 365)),
      ),
    );
  }

  factory CouponModel.fromFirestore(DocumentSnapshot doc) {
    return CouponModel.fromMap({...mapFromValue(doc.data()), 'code': doc.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'discount': discount,
      'type': type.name,
      'description': description,
      'maxDiscount': maxDiscount,
      'minOrder': minOrder,
      'isActive': isActive,
      'expiryDate': Timestamp.fromDate(expiryDate),
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get isValid => isActive && !isExpired;

  double calculateDiscount(double subtotal, double deliveryFee) {
    if (!isValid || subtotal < minOrder) return 0;
    return switch (type) {
      CouponType.percentage =>
        (subtotal * (discount / 100))
            .clamp(0, maxDiscount > 0 ? maxDiscount : double.infinity)
            .toDouble(),
      CouponType.flat => discount.clamp(0, subtotal).toDouble(),
      CouponType.freeDelivery => deliveryFee,
    };
  }
}
