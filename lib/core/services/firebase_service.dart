import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../firebase_options.dart';

bool get isFirebaseConfigured {
  final options = DefaultFirebaseOptions.currentPlatform;
  return !options.apiKey.startsWith('YOUR_') &&
      !options.appId.startsWith('YOUR_') &&
      !options.projectId.startsWith('YOUR_');
}

Future<bool> initializeFirebaseSafely() async {
  if (!isFirebaseConfigured) {
    debugPrint(
      'Firebase is not configured yet; running FoodieGo in demo mode.',
    );
    return false;
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return true;
  } catch (error) {
    debugPrint('Firebase initialization failed: $error');
    return false;
  }
}

final firebaseReadyProvider = Provider<bool>((ref) {
  return Firebase.apps.isNotEmpty;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  if (Firebase.apps.isEmpty) return const Stream<User?>.empty();
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  if (Firebase.apps.isEmpty) return null;
  return ref.watch(firebaseAuthProvider).currentUser;
});
