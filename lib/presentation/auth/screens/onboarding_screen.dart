import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/storage/preferences_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _controller = PageController();
  int _index = 0;

  late final AnimationController _contentController;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _fade = CurvedAnimation(parent: _contentController, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _contentController,
            curve: Curves.easeOutCubic,
          ),
        );
    _contentController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(preferencesServiceProvider).setOnboardingDone(true);
    if (mounted) context.go(AppRoutes.roleSelection);
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _index = index);
    _contentController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_index];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: page.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
                  child: Row(
                    children: [
                      Text(
                        'FoodieGo',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          letterSpacing: 0,
                        ),
                      ),
                      const Spacer(),
                      if (_index < _pages.length - 1)
                        TextButton(
                          onPressed: _finish,
                          child: Text(
                            'Skip',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: Colors.white.withValues(alpha: 0.86),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      return _OnboardingPageView(page: _pages[index]);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDimensions.screenPadding,
                    16,
                    AppDimensions.screenPadding,
                    MediaQuery.of(context).padding.bottom + 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: _fade,
                        child: SlideTransition(
                          position: _slide,
                          child: _OnboardingCopy(page: page),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SmoothPageIndicator(
                        controller: _controller,
                        count: _pages.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: Colors.white,
                          dotColor: Colors.white.withValues(alpha: 0.34),
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 6,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: AppDimensions.buttonHeight,
                        child: ElevatedButton.icon(
                          onPressed: _next,
                          icon: Icon(
                            _index == _pages.length - 1
                                ? Icons.check_rounded
                                : Icons.arrow_forward_rounded,
                          ),
                          label: Text(
                            _index == _pages.length - 1
                                ? 'Get Started'
                                : 'Next',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: page.colors.first,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusLG,
                              ),
                            ),
                            textStyle: AppTextStyles.button.copyWith(
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: _finish,
                        child: Text(
                          'Already have an account? Sign in',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final illustrationSize = (constraints.maxWidth * 0.54).clamp(172, 232);
        return Center(
          child: SizedBox(
            width: illustrationSize.toDouble(),
            height: illustrationSize.toDouble(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
              ),
              child: Center(
                child: Container(
                  width: illustrationSize * 0.62,
                  height: illustrationSize * 0.62,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Icon(
                    page.icon,
                    color: page.colors.first,
                    size: illustrationSize * 0.34,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingCopy extends StatelessWidget {
  final _OnboardingPage page;

  const _OnboardingCopy({required this.page});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          page.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.displayMedium.copyWith(
            color: Colors.white,
            letterSpacing: 0,
            height: 1.16,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          page.description,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.84),
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> colors;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.colors,
  });
}

const List<_OnboardingPage> _pages = [
  _OnboardingPage(
    title: 'Order From Favorite Restaurants',
    description:
        'Browse restaurants near you, compare ratings, and find meals that match your craving.',
    icon: Icons.restaurant_rounded,
    colors: [AppColors.primary, Color(0xFFF46036)],
  ),
  _OnboardingPage(
    title: 'Track Every Step',
    description:
        'Follow your order from confirmation to delivery with clear status updates.',
    icon: Icons.delivery_dining_rounded,
    colors: [AppColors.secondary, Color(0xFF138A8A)],
  ),
  _OnboardingPage(
    title: 'Checkout Without Friction',
    description:
        'Use saved addresses, coupons, tips, and flexible payment methods in one smooth flow.',
    icon: Icons.payments_rounded,
    colors: [Color(0xFF3D5A80), Color(0xFF7A4EAB)],
  ),
];
