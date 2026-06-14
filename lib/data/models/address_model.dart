import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_helpers.dart';

enum AddressType { home, office, university, custom }

class AddressModel {
  final String id;
  final String userId;
  final String title;
  final AddressType type;
  final String streetAddress;
  final String city;
  final String postalCode;
  final String? notes;
  final double latitude;
  final double longitude;
  final bool isDefault;
  final DateTime createdAt;

  const AddressModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.streetAddress,
    required this.city,
    required this.postalCode,
    this.notes,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
    required this.createdAt,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: (map['id'] ?? '').toString(),
      userId: (map['userId'] ?? '').toString(),
      title: (map['title'] ?? 'Address').toString(),
      type: AddressType.values.firstWhere(
        (type) => type.name == map['type'],
        orElse: () => AddressType.home,
      ),
      streetAddress: (map['streetAddress'] ?? '').toString(),
      city: (map['city'] ?? '').toString(),
      postalCode: (map['postalCode'] ?? '').toString(),
      notes: map['notes']?.toString(),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
      isDefault: map['isDefault'] as bool? ?? false,
      createdAt: dateTimeFromValue(map['createdAt']),
    );
  }

  factory AddressModel.fromFirestore(DocumentSnapshot doc) {
    return AddressModel.fromMap({...mapFromValue(doc.data()), 'id': doc.id});
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'type': type.name,
      'streetAddress': streetAddress,
      'city': city,
      'postalCode': postalCode,
      'notes': notes,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String get fullAddress => [
    streetAddress,
    city,
    postalCode,
  ].where((part) => part.trim().isNotEmpty).join(', ');

  AddressModel copyWith({
    String? id,
    String? userId,
    String? title,
    AddressType? type,
    String? streetAddress,
    String? city,
    String? postalCode,
    String? notes,
    double? latitude,
    double? longitude,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      type: type ?? this.type,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      notes: notes ?? this.notes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
