import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/notification_model.dart';
import '../../notifications/providers/notification_provider.dart';

class AdminNotificationsScreen extends ConsumerStatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  ConsumerState<AdminNotificationsScreen> createState() =>
      _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState
    extends ConsumerState<AdminNotificationsScreen> {
  final _title = TextEditingController(text: 'New offer');
  final _body = TextEditingController(text: 'Weekend special is now live.');

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.adminDashboard);
            }
          },
        ),
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppTextField(label: 'Title', controller: _title),
          const SizedBox(height: 12),
          AppTextField(label: 'Body', controller: _body, maxLines: 4),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () async {
              await ref
                  .read(notificationActionsProvider.notifier)
                  .sendNotification(
                    title: _title.text,
                    body: _body.text,
                    type: NotificationType.newOffer,
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification sent.')),
                );
              }
            },
            icon: const Icon(Icons.send_rounded),
            label: const Text('Send Notification'),
          ),
        ],
      ),
    );
  }
}
