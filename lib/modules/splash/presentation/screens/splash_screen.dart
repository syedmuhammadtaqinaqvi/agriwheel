import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/auth_session_provider.dart';
import '../../../../core/services/app_prefs.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigateNext());
  }

  Future<void> _navigateNext() async {
    if (!mounted) return;

    final auth = context.read<AuthSessionProvider>();
    final onboardingDone = await AppPrefs.isOnboardingComplete();

    if (!mounted) return;

    if (!onboardingDone) {
      context.go(RouteNames.onboarding);
      return;
    }

    if (auth.isLoggedIn) {
      final setupRoute = auth.postAuthRoute;
      context.go(setupRoute ?? RouteNames.home);
      return;
    }

    context.go(RouteNames.home);
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
                      style: AppTypography.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Buy. Sell. Grow.',
                      style: AppTypography.poppins(fontSize: 14, color: AppColors.yellow),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.lg),
                child: Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.yellow,
                      backgroundColor: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
