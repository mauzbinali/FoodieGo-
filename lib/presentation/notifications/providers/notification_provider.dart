import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/notification_model.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../auth/providers/auth_provider.dart';

final userNotificationsProvider = StreamProvider<List<NotificationModel>>((
  ref,
) {
  final userId = ref.watch(authProvider).user?.uid;
  if (userId == null) return const Stream.empty();
  return ref
      .watch(notificationRepositoryProvider)
      .getUserNotificationsStream(userId);
});

final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final userId = ref.watch(authProvider).user?.uid;
  if (userId == null) return const Stream.empty();
  return ref.watch(notificationRepositoryProvider).getUnreadCountStream(userId);
});

final allNotificationsStreamProvider = StreamProvider<List<NotificationModel>>((
  ref,
) {
  return ref.watch(notificationRepositoryProvider).getAllNotificationsStream();
});

class NotificationActionsNotifier extends StateNotifier<bool> {
  final NotificationRepository _repo;

  NotificationActionsNotifier(this._repo) : super(false);

  Future<void> markAsRead(String id) => _repo.markAsRead(id);
  Future<void> markAllAsRead(String userId) => _repo.markAllAsRead(userId);
  Future<void> deleteNotification(String id) => _repo.deleteNotification(id);

  Future<void> sendNotification({
    required String title,
    required String body,
    required NotificationType type,
    String? userId,
  }) {
    return _repo.sendNotification(
      title: title,
      body: body,
      type: type,
      userId: userId,
    );
  }
}

final notificationActionsProvider =
    StateNotifierProvider<NotificationActionsNotifier, bool>((ref) {
      return NotificationActionsNotifier(
        ref.watch(notificationRepositoryProvider),
      );
    });
