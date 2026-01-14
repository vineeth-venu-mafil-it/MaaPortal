import 'package:flutter/material.dart';

import 'core/helpers/routes/app_route_config.dart';
import 'core/helpers/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MaaPortal',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRoutes(
        rootNavigatorKey: _rootNavigatorKey,
      ).appRouter,
    );
  }
}
