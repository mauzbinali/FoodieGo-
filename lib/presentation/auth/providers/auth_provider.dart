import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/storage/preferences_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({this.user, this.isLoading = false, this.errorMessage});

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final PreferencesService _prefs;

  AuthNotifier({
    required AuthRepository repo,
    required PreferencesService prefs,
  }) : _repo = repo,
       _prefs = prefs,
       super(const AuthState()) {
    _restoreSession();
  }

  void _restoreSession() {
    if (!_prefs.isLoggedIn || _prefs.userId == null) return;
    state = AuthState(
      user: UserModel(
        uid: _prefs.userId!,
        name: _prefs.userName ?? 'FoodieGo User',
        email: _prefs.userEmail ?? '',
        phone: _prefs.userPhone ?? '',
        profileImage: _prefs.userImage,
        role: _prefs.userRole ?? AppConstants.roleCustomer,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<bool> loginWithEmail({
    required String email,
    required String password,
    bool remember = false,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repo.loginWithEmail(email: email, password: password);
      await _saveUser(user);
      if (remember) {
        await _prefs.setRememberLogin(true);
        await _prefs.setSavedEmail(email);
        await _prefs.setSavedPassword(password);
      }
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: _clean(error));
      return false;
    }
  }

  Future<bool> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repo.registerWithEmail(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      await _saveUser(user);
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: _clean(error));
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repo.signInWithGoogle();
      await _saveUser(user);
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: _clean(error));
      return false;
    }
  }

  Future<void> continueAsDemoRole(String role) async {
    final user = switch (role) {
      AppConstants.roleAdmin => UserModel(
        uid: 'demo_admin',
        name: 'FoodieGo Admin',
        email: 'admin@foodiego.local',
        phone: '+92 300 0000001',
        role: AppConstants.roleAdmin,
        createdAt: DateTime.now(),
      ),
      AppConstants.roleOwner => UserModel(
        uid: 'owner_mcdonalds',
        name: 'Restaurant Owner',
        email: 'owner@foodiego.local',
        phone: '+92 300 0000002',
        role: AppConstants.roleOwner,
        restaurantId: 'mcdonalds',
        createdAt: DateTime.now(),
      ),
      _ => UserModel(
        uid: 'demo_customer',
        name: 'FoodieGo Customer',
        email: 'customer@foodiego.local',
        phone: '+92 300 0000003',
        role: AppConstants.roleCustomer,
        createdAt: DateTime.now(),
      ),
    };

    await _saveUser(user);
    state = state.copyWith(user: user, isLoading: false, clearError: true);
  }

  Future<void> sendPasswordResetEmail(String email) =>
      _repo.sendPasswordResetEmail(email);

  Future<void> logout() async {
    await _repo.logout();
    await _prefs.clearAuthData();
    state = state.copyWith(clearUser: true);
  }

  Future<void> _saveUser(UserModel user) {
    return _prefs.saveSession(
      userId: user.uid,
      email: user.email,
      name: user.name,
      role: user.role,
      phone: user.phone,
      imageUrl: user.profileImage,
    );
  }

  void clearError() => state = state.copyWith(clearError: true);

  String _clean(Object error) {
    return error.toString().replaceAll('Exception: ', '');
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    repo: ref.watch(authRepositoryProvider),
    prefs: ref.watch(preferencesServiceProvider),
  );
});

final currentUserModelProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});
