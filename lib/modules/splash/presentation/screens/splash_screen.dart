import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/auth_session_provider.dart';
import '../../../../core/services/app_prefs.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/agri_wheel_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), _navigateNext);
  }

  Future<void> _navigateNext() async {
    if (!mounted) return;
    final auth = context.read<AuthSessionProvider>();
    final onboardingDone = await AppPrefs.isOnboardingComplete();

    while (auth.isLoggedIn && auth.isLoadingProfile) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
    }

    if (!mounted) return;

    if (!onboardingDone) {
      context.go(RouteNames.onboarding);
      return;
    }

    if (auth.isLoggedIn) {
      final setupRoute = auth.postAuthRoute;
      if (setupRoute != null) {
        context.go(setupRoute);
      } else {
        context.go(RouteNames.home);
      }
      return;
    }

    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    final logoSize = (shortest * 0.3).clamp(104.0, 128.0);

    return Scaffold(
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AgriWheelLogo(size: logoSize),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'AgriWheel',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Buy. Sell. Grow.',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.yellow),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 136,
                  height: 4,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.white.withValues(alpha: 0.35),
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
