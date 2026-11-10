import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/providers/auth_session_provider.dart';
import '../core/theme/app_theme.dart';
import '../modules/auth/domain/auth_session.dart';
import 'router/app_router.dart';

class AgriWheelApp extends StatefulWidget {
  const AgriWheelApp({super.key, required this.authProvider});

  final AuthSessionProvider authProvider;

  @override
  State<AgriWheelApp> createState() => _AgriWheelAppState();
}

class _AgriWheelAppState extends State<AgriWheelApp> {
  late final _router = createAppRouter(widget.authProvider);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthSessionProvider>.value(value: widget.authProvider),
      ],
      child: ListenableBuilder(
        listenable: Listenable.merge([widget.authProvider, AuthSession.instance]),
        builder: (context, _) {
          return MaterialApp.router(
            title: 'AgriWheel',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
