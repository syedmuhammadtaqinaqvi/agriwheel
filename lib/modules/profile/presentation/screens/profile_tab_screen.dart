import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/auth_session_provider.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../auth/domain/auth_session.dart';
import 'buyer_account_screen.dart';
import 'profile_screen.dart';
import 'seller_account_screen.dart';

/// Profile tab switches UI by auth role.
class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthSessionProvider>();

    return ListenableBuilder(
      listenable: AuthSession.instance,
      builder: (context, _) {
        final role = AuthSession.instance.role;

        if (auth.isLoggedIn && role == UserRole.guest && auth.isLoadingProfile) {
          return const ColoredBox(
            color: Colors.white,
            child: Center(child: LoadingView(message: 'Loading profile…')),
          );
        }

        final child = switch (role) {
          UserRole.guest => const ProfileScreen(),
          UserRole.buyer => const BuyerAccountScreen(),
          UserRole.seller => const SellerAccountScreen(),
        };

        return ColoredBox(
          color: Colors.white,
          child: SizedBox.expand(child: child),
        );
      },
    );
  }
}
