import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auth_stack_app_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../domain/auth_flow_type.dart';
import '../widgets/otp_input_section.dart';

/// Single OTP screen for buyer & seller (HTML screens 2 and 6 merged).
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.args});

  final OtpRouteArgs args;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool _verified = false;

  void _continue() {
    final next = switch (widget.args.flow) {
      AuthFlowType.buyer => RouteNames.buyerProfile,
      AuthFlowType.seller => RouteNames.sellerDealership,
      AuthFlowType.passwordReset => RouteNames.resetPassword,
    };
    context.push(next);
  }

  @override
  Widget build(BuildContext context) {
    final buyerStyle = widget.args.showCustomKeypad;
    return Scaffold(
      appBar: const AuthStackAppBar(screenTitle: 'Otp Verification'),
      body: ResponsiveBody(
        child: ListView(
          children: [
            if (buyerStyle) ...[
              _SecurityBanner(),
              const SizedBox(height: AppSpacing.lg),
              Text('Verify Phone Number', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'We have sent a 4-digit verification code to',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              _PhoneChip(phone: widget.args.phoneDisplay),
            ] else ...[
              Chip(
                avatar: const Icon(Icons.verified_user, size: 18),
                label: const Text('MANDI SECURITY CHECK'),
                backgroundColor: AppColors.secondaryContainer,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    const TextSpan(text: 'We have sent a 4-digit verification code to '),
                    TextSpan(text: widget.args.phoneDisplay, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            OtpInputSection(
              showKeypad: widget.args.showCustomKeypad,
              onCompleted: (_) => setState(() => _verified = true),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: _verified ? 'Verified' : 'Verify & Continue',
              icon: Icons.arrow_forward,
              secondaryStyle: _verified,
              onPressed: _continue,
            ),
            if (!buyerStyle) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: _TrustCard(icon: Icons.speed, title: 'Instant Post', body: 'Live to 100k+ buyers across Punjab & Sindh')),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: _TrustCard(icon: Icons.shield, title: 'Zero Fraud', body: 'Verified phone for authentic farm transactions')),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SecurityBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: AppColors.surfaceLow, borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
            child: const Icon(Icons.phonelink_lock, color: AppColors.brand),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SMS Security Code', style: Theme.of(context).textTheme.titleMedium),
                Text('Instant AgriWheel operator login', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.verified_user, size: 18),
        ],
      ),
    );
  }
}

class _PhoneChip extends StatelessWidget {
  const _PhoneChip({required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
        decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.call, size: 16),
            const SizedBox(width: 6),
            Text(phone, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _TrustCard extends StatelessWidget {
  const _TrustCard({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.brand),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(body, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
