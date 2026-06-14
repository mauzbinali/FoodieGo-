import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    auth: Firebase.apps.isEmpty ? null : FirebaseAuth.instance,
    firestore: Firebase.apps.isEmpty ? null : FirebaseFirestore.instance,
  );
});

class AuthRepository {
  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth,
      _firestore = firestore;

  bool get _hasFirebase => Firebase.apps.isNotEmpty && _auth != null;

  Stream<User?> get authStateChanges {
    if (!_hasFirebase) return const Stream<User?>.empty();
    return _auth!.authStateChanges();
  }

  User? get currentUser => _hasFirebase ? _auth!.currentUser : null;

  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (!_hasFirebase || _firestore == null) {
      return UserModel(
        uid: 'demo_${email.hashCode.abs()}',
        name: name,
        email: email,
        phone: phone,
        createdAt: DateTime.now(),
      );
    }

    try {
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      await user.updateDisplayName(name);
      await user.sendEmailVerification();

      final model = UserModel(
        uid: user.uid,
        name: name,
        email: email,
        phone: phone,
        role: AppConstants.roleCustomer,
        createdAt: DateTime.now(),
      );
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(model.toMap());
      return model;
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapFirebaseError(error.code));
    } catch (_) {
      throw const AuthException('Registration failed. Please try again.');
    }
  }

  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    if (!_hasFirebase || _firestore == null) {
      return UserModel(
        uid: 'demo_${email.hashCode.abs()}',
        name: email.split('@').first,
        email: email,
        phone: '',
        createdAt: DateTime.now(),
      );
    }

    try {
      final credential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _getOrCreateUserModel(credential.user!);
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapFirebaseError(error.code));
    } catch (_) {
      throw const AuthException('Login failed. Please try again.');
    }
  }

  Future<UserModel> signInWithGoogle() async {
    if (!_hasFirebase || _firestore == null) {
      return UserModel.guest();
    }

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException('Google sign-in cancelled.');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth!.signInWithCredential(credential);
      return _getOrCreateUserModel(userCredential.user!);
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapFirebaseError(error.code));
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException('Google sign-in failed. Please try again.');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (!_hasFirebase) return;
    await _auth!.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    if (!_hasFirebase) return;
    await _auth!.currentUser?.sendEmailVerification();
  }

  Future<void> reloadUser() async {
    if (!_hasFirebase) return;
    await _auth!.currentUser?.reload();
  }

  bool get isEmailVerified =>
      !_hasFirebase || (_auth!.currentUser?.emailVerified ?? false);

  Future<UserModel?> getCurrentUserModel() async {
    final user = currentUser;
    if (user == null || _firestore == null) return null;
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .get();
    return doc.exists ? UserModel.fromFirestore(doc) : null;
  }

  Stream<UserModel?> getUserStream(String uid) {
    if (_firestore == null) return Stream.value(UserModel.guest());
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? phone,
    String? profileImage,
    String? fcmToken,
  }) async {
    if (_firestore == null) return;
    final updates = <String, dynamic>{'updatedAt': Timestamp.now()};
    if (name != null) updates['name'] = name;
    if (phone != null) updates['phone'] = phone;
    if (profileImage != null) updates['profileImage'] = profileImage;
    if (fcmToken != null) updates['fcmToken'] = fcmToken;
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .update(updates);
  }

  Future<void> logout() async {
    if (!_hasFirebase) return;
    await _googleSignIn.signOut();
    await _auth!.signOut();
  }

  Future<UserModel> _getOrCreateUserModel(User user) async {
    final firestore = _firestore;
    if (firestore == null) {
      return UserModel(
        uid: user.uid,
        name: user.displayName ?? 'User',
        email: user.email ?? '',
        phone: user.phoneNumber ?? '',
        profileImage: user.photoURL,
        role: AppConstants.roleCustomer,
        createdAt: DateTime.now(),
      );
    }

    final doc = await firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .get();
    if (doc.exists) return UserModel.fromFirestore(doc);

    final model = UserModel(
      uid: user.uid,
      name: user.displayName ?? 'User',
      email: user.email ?? '',
      phone: user.phoneNumber ?? '',
      profileImage: user.photoURL,
      role: AppConstants.roleCustomer,
      createdAt: DateTime.now(),
    );
    await firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(model.toMap());
    return model;
  }

  String _mapFirebaseError(String code) {
    return switch (code) {
      'user-not-found' => 'No account found with this email.',
      'wrong-password' => 'Incorrect password. Please try again.',
      'email-already-in-use' => 'An account already exists with this email.',
      'invalid-email' => 'Please enter a valid email address.',
      'weak-password' => 'Password must be at least 6 characters.',
      'network-request-failed' => 'No internet connection.',
      'too-many-requests' => 'Too many attempts. Please try again later.',
      'invalid-credential' => 'Invalid credentials. Please try again.',
      _ => 'Authentication failed. Please try again.',
    };
  }
}
