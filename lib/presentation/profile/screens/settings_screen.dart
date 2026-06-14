import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../shared/foodiego_ui.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    return FoodieGoScaffold(
      title: 'Settings',
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const Text('Theme'),
              const SizedBox(height: 8),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('System'),
                    icon: Icon(Icons.phone_android_rounded),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('Light'),
                    icon: Icon(Icons.light_mode_rounded),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('Dark'),
                    icon: Icon(Icons.dark_mode_rounded),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (value) =>
                    ref.read(themeModeProvider.notifier).setTheme(value.first),
              ),
              const SizedBox(height: 24),
              const Text('Language'),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'en', label: Text('English')),
                  ButtonSegment(value: 'ur', label: Text('Urdu')),
                ],
                selected: {locale.languageCode},
                onSelectionChanged: (value) => ref
                    .read(localeProvider.notifier)
                    .setLocale(Locale(value.first)),
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                value: true,
                onChanged: (_) {},
                title: const Text('Order notifications'),
                subtitle: const Text('Accepted, preparing, rider assigned'),
              ),
              SwitchListTile(
                value: true,
                onChanged: (_) {},
                title: const Text('Promotional notifications'),
                subtitle: const Text('Offers, coupons, weekend specials'),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
