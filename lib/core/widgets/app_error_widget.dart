import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final IconData icon;

  const AppErrorWidget({
    super.key,
    this.message = 'Something went wrong',
    this.onRetry,
    this.retryLabel = 'Retry',
    this.icon = Icons.error_outline_rounded,
  });

  const AppErrorWidget.noInternet({
    super.key,
    this.onRetry,
    this.retryLabel = 'Retry',
  }) : message = 'No internet connection',
       icon = Icons.wifi_off_rounded;

  const AppErrorWidget.empty({
    super.key,
    this.message = 'No results found',
    this.onRetry,
    this.retryLabel,
  }) : icon = Icons.search_off_rounded;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(
                label: retryLabel ?? 'Retry',
                onPressed: onRetry,
                isFullWidth: false,
                width: 140,
                height: 44,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
