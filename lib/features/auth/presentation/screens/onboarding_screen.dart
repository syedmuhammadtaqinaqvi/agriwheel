import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/app_prefs.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/responsive_body.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _page = 0;

  static const _slides = [
    _SlideData(
      icon: Icons.search,
      title: 'Browse Farm Machinery',
      body: 'Tractors, harvesters, trolleys and tools listed across Pakistan.',
    ),
    _SlideData(
      icon: Icons.chat_bubble_outline,
      title: 'Chat with Sellers',
      body: 'Message dealers and call when you find the right machine.',
    ),
    _SlideData(
      icon: Icons.add_circle_outline,
      title: 'Post Your Ads',
      body: 'Sellers publish photos and prices in minutes.',
    ),
  ];

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await AppPrefs.setOnboardingComplete();
    if (!mounted) return;
    context.go(RouteNames.chooseRole);
  }

  void _next() {
    if (_page < _slides.length - 1) {
      _pageCtrl.nextPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: ResponsiveBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: Text('Skip', style: GoogleFonts.poppins(color: AppColors.green, fontWeight: FontWeight.w600)),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.42,
              child: PageView.builder(
                controller: _pageCtrl,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                          border: Border.all(color: AppColors.green, width: 2),
                        ),
                        child: Icon(slide.icon, size: 32, color: AppColors.green),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        slide.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.green),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        slide.body,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 14, height: 1.4, color: AppColors.green),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? AppColors.yellow : AppColors.white,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: AppColors.green, width: 1),
                  ),
                );
              }),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: _page == _slides.length - 1 ? 'Get started' : 'Next', onPressed: _next),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _SlideData {
  const _SlideData({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;
}
