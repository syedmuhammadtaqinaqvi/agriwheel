import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:agriwheel/core/theme/app_theme.dart';
import 'package:agriwheel/modules/auth/domain/auth_session.dart';
import 'package:agriwheel/modules/profile/presentation/screens/buyer_account_screen.dart';

void main() {
  testWidgets('Buyer profile tab shows scrollable content inside tab shell', (tester) async {
    AuthSession.instance.loginAsBuyer(name: 'Test Buyer', phoneNumber: '+92 300 0000000');

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const ColoredBox(
          color: Colors.white,
          child: SizedBox.expand(child: BuyerAccountScreen()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Edit Profile'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);

    AuthSession.instance.logout();
  });
}
