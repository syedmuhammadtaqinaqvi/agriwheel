import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/agri_wheel_logo.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../features/listings/data/listings_repository.dart';

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  final _repo = const ListingsRepository();
  bool _loading = false;
  String? _result;
  bool? _success;

  Future<void> _test() async {
    setState(() {
      _loading = true;
      _result = null;
      _success = null;
    });
    try {
      await _repo.pingListings();
      if (!mounted) return;
      setState(() {
        _loading = false;
        _success = true;
        _result = 'Connected';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _success = false;
        _result = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.margin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              const AgriWheelLogo(size: 88),
              const SizedBox(height: AppSpacing.md),
              Text('AgriWheel', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.white)),
              Text('Supabase connection test', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.yellow)),
              const Spacer(),
              if (_loading) const LoadingView(message: 'Checking listings table…'),
              if (!_loading && _result != null)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    border: Border.all(color: AppColors.green, width: 1.5),
                  ),
                  child: Text(
                    _result!,
                    style: TextStyle(
                      color: _success == true ? AppColors.green : AppColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              AppButton(label: 'Test connection', onPressed: _test, isLoading: _loading),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'Open legacy app shell',
                variant: AppButtonVariant.secondary,
                onPressed: () => context.go(RouteNames.splash),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
