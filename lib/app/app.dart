import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../_shared/services/interaction_connector.dart';
import '../_shared/theme/app_theme.dart';
import '../features/auth/manager/auth_manager.dart';
import '../features/auth/pages/landing_page.dart';
import '../features/home/pages/home_page.dart';
import 'routes.dart';

class PlantManagerApp extends WatchingWidget {
  const PlantManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgroCare',
      theme: AppTheme.light,
      builder: (context, child) =>
          InteractionConnector(child: child ?? const SizedBox.shrink()),
      home: const _AppGate(),
      routes: AppRoutes.routes,
    );
  }
}

class _AppGate extends WatchingWidget {
  const _AppGate();

  @override
  Widget build(BuildContext context) {
    if (!allReady()) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = watchValue((AuthManager m) => m.userState);
    if (user == null) {
      return const LandingPage();
    }
    return const HomePage();
  }
}
