import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/auth_session_provider.dart';
import '../../../../core/services/app_prefs.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/widgets/auth_stack_app_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/responsive_body.dart';
import '../../../../features/auth/data/auth_repository.dart';

class SellerSignupScreen extends StatefulWidget {
  const SellerSignupScreen({super.key});

  @override
  State<SellerSignupScreen> createState() => _SellerSignupScreenState();
}

class _SellerSignupScreenState extends State<SellerSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _authRepo = const AuthRepository();
  bool _obscure = true;
  bool _terms = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String get _phoneE164 => '+92${_phoneCtrl.text.replaceAll(RegExp(r'\D'), '')}';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || !_terms) return;
    setState(() => _loading = true);
    try {
      final res = await _authRepo.signUp(
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
        fullName: _nameCtrl.text,
        phone: _phoneE164,
        role: 'seller',
      );
      await AppPrefs.clearPendingSignupRole();
      if (!mounted) return;
      if (res.session == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Account created. If login fails, confirm your email (link opens agriwheel.vercel.app) or turn off “Confirm email” in Supabase for testing.',
            ),
            duration: Duration(seconds: 6),
          ),
        );
        context.go(RouteNames.login);
        return;
      }
      final auth = context.read<AuthSessionProvider>();
      await auth.ensureProfileLoaded();
      if (!mounted) return;
      context.go(auth.postAuthRoute ?? RouteNames.sellerDealership);
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
      appBar: AuthStackAppBar(screenTitle: 'Seller Sign Up'),
      body: ResponsiveBody(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _ValueCard(),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Phone Number', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              _PhoneField(controller: _phoneCtrl),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CheckboxListTile(
                value: _terms,
                onChanged: (v) => setState(() => _terms = v ?? false),
                title: const Text('I agree to AgriWheel Mandi Seller Terms & Trade Policy.'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              PrimaryButton(
                label: 'Create Account',
                icon: Icons.arrow_forward,
                isLoading: _loading,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: TextButton(
                  onPressed: () => context.go(RouteNames.buyerSignup),
                  child: const Text('Buying instead? Create buyer account'),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => context.go(RouteNames.login),
                  child: const Text('Already have an account? Log In'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.brand, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: const Text('CERTIFIED SELLER NETWORK'),
                backgroundColor: AppColors.secondaryContainer,
                labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          Text('Sell Machinery Directly Across Pakistan', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'List tractors, harvesters, and implements with direct buyer inquiries.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.fieldHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.brand, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: const BoxDecoration(border: Border(right: BorderSide(color: AppColors.brand, width: 2))),
            alignment: Alignment.center,
            child: const Text('+92', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: '300 9876543',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              ),
              validator: (v) => (v == null || v.length < 10) ? 'Enter valid number' : null,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
            child: Icon(Icons.phone_iphone),
          ),
        ],
      ),
    );
  }
}
