import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maaportal/features/home/view/home_page.dart';

import '../../../features/login/view/login_page.dart';
import '../../../features/splash/view/splash_page.dart';
import 'app_route_name.dart';
import 'app_route_path.dart';

class AppRoutes {
  final GlobalKey<NavigatorState> rootNavigatorKey;
  late final GoRouter appRouter;
  AppRoutes({
    required this.rootNavigatorKey,
  }) {
    appRouter = GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: RoutesPath.login,
        routes: [
          GoRoute(
            name: RoutesName.splash,
            path: RoutesPath.splash,
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const SplashWrapper(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            name: RoutesName.login,
            path: RoutesPath.login,
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: LoginWrapper(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
          ),  GoRoute(
            name: RoutesName.home,
            path: RoutesPath.home,
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: HomeWrapper(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          ),
        ]);
  }
}
