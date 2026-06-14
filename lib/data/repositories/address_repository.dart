import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/address_model.dart';

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository();
});

class AddressRepository {
  static final Map<String, List<AddressModel>> _addressesByUser = {};
  final Uuid _uuid = const Uuid();

  Future<List<AddressModel>> getAddresses(String userId) async {
    return List<AddressModel>.from(_addressesByUser[userId] ?? []);
  }

  Stream<List<AddressModel>> getAddressesStream(String userId) {
    return Stream.value(
      List<AddressModel>.from(_addressesByUser[userId] ?? []),
    );
  }

  Future<AddressModel> addAddress({
    required String userId,
    required String title,
    required AddressType type,
    required String streetAddress,
    required String city,
    required String postalCode,
    String? notes,
    required double latitude,
    required double longitude,
    bool isDefault = false,
  }) async {
    var address = AddressModel(
      id: _uuid.v4(),
      userId: userId,
      title: title,
      type: type,
      streetAddress: streetAddress,
      city: city,
      postalCode: postalCode,
      notes: notes,
      latitude: latitude,
      longitude: longitude,
      isDefault: isDefault,
      createdAt: DateTime.now(),
    );
    final addresses = _addressesByUser.putIfAbsent(userId, () => []);
    if (isDefault || addresses.isEmpty) {
      _addressesByUser[userId] = addresses
          .map((item) => item.copyWith(isDefault: false))
          .toList();
      address = address.copyWith(isDefault: true);
    }
    _addressesByUser[userId] = [...(_addressesByUser[userId] ?? []), address];
    return address;
  }

  Future<void> updateAddress(String userId, AddressModel address) async {
    final addresses = _addressesByUser[userId] ?? [];
    _addressesByUser[userId] = addresses
        .map((item) => item.id == address.id ? address : item)
        .toList();
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    final addresses = _addressesByUser[userId] ?? [];
    _addressesByUser[userId] = addresses
        .where((item) => item.id != addressId)
        .toList();
  }

  Future<void> setDefaultAddress(String userId, String addressId) async {
    final addresses = _addressesByUser[userId] ?? [];
    _addressesByUser[userId] = addresses
        .map((item) => item.copyWith(isDefault: item.id == addressId))
        .toList();
  }
}
