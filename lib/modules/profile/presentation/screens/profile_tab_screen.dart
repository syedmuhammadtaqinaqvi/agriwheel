import 'package:flutter/material.dart';

import '../../../auth/domain/auth_session.dart';
import 'buyer_account_screen.dart';
import 'profile_screen.dart';
import 'seller_account_screen.dart';

/// Profile tab switches UI by auth role.
class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthSession.instance,
      builder: (context, _) {
        return switch (AuthSession.instance.role) {
          UserRole.guest => const ProfileScreen(),
          UserRole.buyer => const BuyerAccountScreen(),
          UserRole.seller => const SellerAccountScreen(),
        };
      },
    );
  }
}
