import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import 'model_helpers.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final String role;
  final String? restaurantId;
  final bool isActive;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    this.role = AppConstants.roleCustomer,
    this.restaurantId,
    this.isActive = true,
    this.fcmToken,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserModel.guest() {
    return UserModel(
      uid: 'guest',
      name: 'Guest Customer',
      email: 'guest@foodiego.local',
      phone: '',
      role: AppConstants.roleCustomer,
      createdAt: DateTime.now(),
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: (map['uid'] ?? map['id'] ?? '').toString(),
      name: (map['name'] ?? 'User').toString(),
      email: (map['email'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      profileImage: map['profileImage']?.toString(),
      role: (map['role'] ?? AppConstants.roleCustomer).toString(),
      restaurantId: map['restaurantId']?.toString(),
      isActive: map['isActive'] as bool? ?? true,
      fcmToken: map['fcmToken']?.toString(),
      createdAt: dateTimeFromValue(map['createdAt']),
      updatedAt: map['updatedAt'] == null
          ? null
          : dateTimeFromValue(map['updatedAt']),
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel.fromMap({...mapFromValue(doc.data()), 'uid': doc.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'role': role,
      'restaurantId': restaurantId,
      'isActive': isActive,
      'fcmToken': fcmToken,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
  }

  bool get isCustomer => role == AppConstants.roleCustomer;
  bool get isOwner => role == AppConstants.roleOwner;
  bool get isAdmin => role == AppConstants.roleAdmin;

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? role,
    String? restaurantId,
    bool? isActive,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      restaurantId: restaurantId ?? this.restaurantId,
      isActive: isActive ?? this.isActive,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UserModel && other.uid == uid;

  @override
  int get hashCode => uid.hashCode;
}
