import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/theme_provider.dart';
import 'storage_keys.dart';

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  return PreferencesService(ref.watch(sharedPreferencesProvider));
});

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  bool get isLoggedIn => _prefs.getBool(StorageKeys.isLoggedIn) ?? false;
  Future<void> setLoggedIn(bool value) =>
      _prefs.setBool(StorageKeys.isLoggedIn, value);

  String? get userId => _prefs.getString(StorageKeys.userId);
  Future<void> setUserId(String value) =>
      _prefs.setString(StorageKeys.userId, value);

  String? get userRole => _prefs.getString(StorageKeys.userRole);
  Future<void> setUserRole(String value) =>
      _prefs.setString(StorageKeys.userRole, value);

  String? get userEmail => _prefs.getString(StorageKeys.userEmail);
  Future<void> setUserEmail(String value) =>
      _prefs.setString(StorageKeys.userEmail, value);

  String? get userName => _prefs.getString(StorageKeys.userName);
  Future<void> setUserName(String value) =>
      _prefs.setString(StorageKeys.userName, value);

  String? get userPhone => _prefs.getString(StorageKeys.userPhone);
  Future<void> setUserPhone(String value) =>
      _prefs.setString(StorageKeys.userPhone, value);

  String? get userImage => _prefs.getString(StorageKeys.userImage);
  Future<void> setUserImage(String value) =>
      _prefs.setString(StorageKeys.userImage, value);

  bool get isOnboardingDone =>
      _prefs.getBool(StorageKeys.isOnboardingDone) ?? false;
  Future<void> setOnboardingDone(bool value) =>
      _prefs.setBool(StorageKeys.isOnboardingDone, value);

  bool get rememberLogin => _prefs.getBool(StorageKeys.rememberLogin) ?? false;
  Future<void> setRememberLogin(bool value) =>
      _prefs.setBool(StorageKeys.rememberLogin, value);

  String? get savedEmail => _prefs.getString(StorageKeys.savedEmail);
  Future<void> setSavedEmail(String value) =>
      _prefs.setString(StorageKeys.savedEmail, value);

  String? get savedPassword => _prefs.getString(StorageKeys.savedPassword);
  Future<void> setSavedPassword(String value) =>
      _prefs.setString(StorageKeys.savedPassword, value);

  Future<void> clearSavedCredentials() async {
    await _prefs.remove(StorageKeys.savedEmail);
    await _prefs.remove(StorageKeys.savedPassword);
  }

  String? get fcmToken => _prefs.getString(StorageKeys.fcmToken);
  Future<void> setFcmToken(String value) =>
      _prefs.setString(StorageKeys.fcmToken, value);

  bool get notificationsEnabled =>
      _prefs.getBool(StorageKeys.notificationsEnabled) ?? true;
  Future<void> setNotificationsEnabled(bool value) =>
      _prefs.setBool(StorageKeys.notificationsEnabled, value);

  bool get orderNotifications =>
      _prefs.getBool(StorageKeys.orderNotifications) ?? true;
  Future<void> setOrderNotifications(bool value) =>
      _prefs.setBool(StorageKeys.orderNotifications, value);

  bool get promoNotifications =>
      _prefs.getBool(StorageKeys.promoNotifications) ?? true;
  Future<void> setPromoNotifications(bool value) =>
      _prefs.setBool(StorageKeys.promoNotifications, value);

  DateTime? get lastSyncTime {
    final milliseconds = _prefs.getInt(StorageKeys.lastSyncTime);
    if (milliseconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  Future<void> setLastSyncTime(DateTime value) =>
      _prefs.setInt(StorageKeys.lastSyncTime, value.millisecondsSinceEpoch);

  Future<void> saveSession({
    required String userId,
    required String email,
    required String name,
    required String role,
    String? phone,
    String? imageUrl,
  }) async {
    await setLoggedIn(true);
    await setUserId(userId);
    await setUserEmail(email);
    await setUserName(name);
    await setUserRole(role);
    if (phone != null) await setUserPhone(phone);
    if (imageUrl != null) await setUserImage(imageUrl);
  }

  Future<void> clearAuthData() async {
    await _prefs.remove(StorageKeys.isLoggedIn);
    await _prefs.remove(StorageKeys.userId);
    await _prefs.remove(StorageKeys.userRole);
    await _prefs.remove(StorageKeys.userEmail);
    await _prefs.remove(StorageKeys.userName);
    await _prefs.remove(StorageKeys.userPhone);
    await _prefs.remove(StorageKeys.userImage);
    await _prefs.remove(StorageKeys.fcmToken);
  }

  Future<void> clearAllPreservingOnboarding() async {
    final onboardingDone = isOnboardingDone;
    await _prefs.clear();
    await setOnboardingDone(onboardingDone);
  }
}
