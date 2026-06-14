import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../models/coupon_model.dart';
import 'demo_data.dart';

final couponRepositoryProvider = Provider<CouponRepository>((ref) {
  return CouponRepository(
    Firebase.apps.isEmpty ? null : FirebaseFirestore.instance,
  );
});

class CouponRepository {
  final FirebaseFirestore? _firestore;

  CouponRepository(this._firestore);

  CollectionReference<Map<String, dynamic>>? get _collection =>
      _firestore?.collection(AppConstants.couponsCollection);

  Future<List<CouponModel>> getCoupons() async {
    if (_collection == null) return DemoData.coupons;
    final snapshot = await _collection!.get();
    return snapshot.docs.map(CouponModel.fromFirestore).toList();
  }

  Future<CouponModel?> getCoupon(String code) async {
    final normalized = code.trim().toUpperCase();
    if (_collection == null) {
      return DemoData.coupons
          .where((coupon) => coupon.code == normalized)
          .firstOrNull;
    }
    final doc = await _collection!.doc(normalized).get();
    return doc.exists ? CouponModel.fromFirestore(doc) : null;
  }

  Future<CouponModel?> validateCoupon(String code, double subtotal) async {
    final coupon = await getCoupon(code);
    if (coupon == null || !coupon.isValid || subtotal < coupon.minOrder) {
      return null;
    }
    return coupon;
  }

  Future<void> upsertCoupon(CouponModel coupon) async {
    if (_collection == null) return;
    await _collection!.doc(coupon.code).set(coupon.toMap());
  }

  Future<void> deleteCoupon(String code) async {
    if (_collection == null) return;
    await _collection!.doc(code).delete();
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
