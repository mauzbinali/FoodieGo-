import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/address_model.dart';
import '../../../data/repositories/address_repository.dart';
import '../../auth/providers/auth_provider.dart';

class AddressState {
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;
  final bool isLoading;
  final String? errorMessage;

  const AddressState({
    this.addresses = const [],
    this.selectedAddress,
    this.isLoading = false,
    this.errorMessage,
  });

  AddressState copyWith({
    List<AddressModel>? addresses,
    AddressModel? selectedAddress,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AddressNotifier extends StateNotifier<AddressState> {
  final AddressRepository _repo;
  final String _userId;

  AddressNotifier({required AddressRepository repo, required String userId})
    : _repo = repo,
      _userId = userId,
      super(const AddressState()) {
    if (_userId.isNotEmpty) loadAddresses();
  }

  Future<void> loadAddresses() async {
    state = state.copyWith(isLoading: true);
    final addresses = await _repo.getAddresses(_userId);
    final selected =
        addresses.where((item) => item.isDefault).firstOrNull ??
        (addresses.isEmpty ? null : addresses.first);
    state = state.copyWith(
      addresses: addresses,
      selectedAddress: selected,
      isLoading: false,
    );
  }

  Future<bool> addAddress({
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
    try {
      final address = await _repo.addAddress(
        userId: _userId,
        title: title,
        type: type,
        streetAddress: streetAddress,
        city: city,
        postalCode: postalCode,
        notes: notes,
        latitude: latitude,
        longitude: longitude,
        isDefault: isDefault,
      );
      state = state.copyWith(
        addresses: [...state.addresses, address],
        selectedAddress: isDefault || state.selectedAddress == null
            ? address
            : state.selectedAddress,
      );
      return true;
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
      return false;
    }
  }

  Future<void> deleteAddress(String id) async {
    await _repo.deleteAddress(_userId, id);
    await loadAddresses();
  }

  void selectAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address);
  }
}

final addressProvider = StateNotifierProvider<AddressNotifier, AddressState>((
  ref,
) {
  final userId = ref.watch(authProvider).user?.uid ?? '';
  return AddressNotifier(
    repo: ref.watch(addressRepositoryProvider),
    userId: userId,
  );
});

final addressesStreamProvider =
    StreamProvider.family<List<AddressModel>, String>((ref, userId) {
      return ref.watch(addressRepositoryProvider).getAddressesStream(userId);
    });

final selectedAddressProvider = Provider<AddressModel?>((ref) {
  return ref.watch(addressProvider).selectedAddress;
});

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
