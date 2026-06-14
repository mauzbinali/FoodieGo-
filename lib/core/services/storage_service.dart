import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'firebase_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.watch(firebaseStorageProvider));
});

class StorageService {
  final FirebaseStorage _storage;
  final Uuid _uuid = const Uuid();

  StorageService(this._storage);

  Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) {
    return _uploadImage('users/$userId/profile', imageFile);
  }

  Future<String> uploadRestaurantImage({
    required String restaurantId,
    required File imageFile,
  }) {
    return _uploadImage('restaurants/$restaurantId', imageFile);
  }

  Future<String> uploadFoodImage({
    required String foodId,
    required File imageFile,
  }) {
    return _uploadImage('foods/$foodId', imageFile);
  }

  Future<String> uploadReviewImage({
    required String reviewId,
    required File imageFile,
  }) {
    return _uploadImage('reviews/$reviewId', imageFile);
  }

  Future<String> _uploadImage(String path, File imageFile) async {
    final ref = _storage.ref('$path/${_uuid.v4()}.jpg');
    final task = await ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return task.ref.getDownloadURL();
  }

  Future<void> deleteFile(String downloadUrl) async {
    try {
      await _storage.refFromURL(downloadUrl).delete();
    } catch (_) {
      // Ignore missing files and already-deleted objects.
    }
  }
}
