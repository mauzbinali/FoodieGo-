import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';

class EmailVerificationScreen extends ConsumerWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.successSurface,
                child: Icon(
                  Icons.mark_email_read_rounded,
                  size: 42,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Verify your email',
                style: AppTextStyles.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'In demo mode you can continue immediately. With real Firebase, this screen sends and checks verification email status.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.main),
                child: const Text('Continue to FoodieGo'),
              ),
              TextButton(
                onPressed: () async {
                  await ref
                      .read(authProvider.notifier)
                      .sendPasswordResetEmail(
                        ref.read(authProvider).user?.email ?? '',
                      );
                },
                child: const Text('Resend Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
