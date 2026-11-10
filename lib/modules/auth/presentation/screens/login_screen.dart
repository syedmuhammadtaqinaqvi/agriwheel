import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/auth_session_provider.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/widgets/agri_emblem.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../features/auth/data/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  final _authRepo = const AuthRepository();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _authRepo.signIn(email: _emailCtrl.text, password: _passwordCtrl.text);
      if (!mounted) return;
      final auth = context.read<AuthSessionProvider>();
      await auth.refreshProfile();
      if (!mounted) return;
      final next = auth.postAuthRoute ?? RouteNames.home;
      context.go(next);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyAuthError(e))));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: ResponsiveBody(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              children: [
                Column(
                  children: [
                    const AgriEmblem(size: 64),
                    const SizedBox(height: AppSpacing.sm),
                    Text('AgriWheel', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.brand)),
                    const SizedBox(height: 4),
                    Container(width: 32, height: 4, decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(4))),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Welcome Back', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
                Text('Log in with your email and password', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter your email';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Enter your password' : null,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () => context.push(RouteNames.forgotPassword), child: const Text('Forgot Password?')),
                ),
                PrimaryButton(
                  label: 'Log In',
                  onPressed: _submit,
                  isLoading: _loading,
                ),
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: TextButton(
                    onPressed: () => context.go(RouteNames.chooseRole),
                    child: const Text.rich(
                      TextSpan(
                        text: 'New to AgriWheel? ',
                        children: [TextSpan(text: 'Sign Up', style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline))],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => context.go(RouteNames.home),
                  child: const Text('Browse tractors without signing in'),
                ),
                TextButton(
                  onPressed: () => context.go(RouteNames.connectionTest),
                  child: const Text('Supabase connection test'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
