import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'hive_service.dart';
import 'preferences_service.dart';

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSource(
    hive: ref.watch(hiveServiceProvider),
    prefs: ref.watch(preferencesServiceProvider),
  );
});

class LocalDataSource {
  final HiveService hive;
  final PreferencesService prefs;

  LocalDataSource({required this.hive, required this.prefs});

  Future<void> saveSession({
    required String userId,
    required String email,
    required String name,
    required String role,
    String? phone,
    String? imageUrl,
  }) {
    return prefs.saveSession(
      userId: userId,
      email: email,
      name: name,
      role: role,
      phone: phone,
      imageUrl: imageUrl,
    );
  }

  Future<void> clearSession() async {
    await prefs.clearAuthData();
    await hive.clearAllUserData();
  }

  bool get isLoggedIn => prefs.isLoggedIn;
  String? get userId => prefs.userId;
  String? get userRole => prefs.userRole;
}
