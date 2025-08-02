import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../modules/onboard/presentation/screens/onboard_screen.dart';
import '../../modules/signin/presentation/screens/sign_in_loading_screen.dart';
import '../../modules/signin/presentation/screens/sign_in_with_email_screen.dart';
import '../../modules/signin/presentation/screens/sign_in_with_phone_screen.dart';
import '../../modules/splash/presentation/screens/nowhere_screen.dart';
import '../../modules/splash/presentation/screens/splash_screen.dart';
import 'rt_nm.dart';

class AppNav {
  AppNav._();

  /// This field hold the state of [Navigator] widget
  /// which manage a stack of pages in the application
  ///
  /// This field will give the power to access of the
  /// application navigation outside of a context scope
  static final navKey = GlobalKey<NavigatorState>();

  static final shellNavKey = GlobalKey<NavigatorState>();
  static final advisorShellNavKey = GlobalKey<NavigatorState>();

  /// This key is used to access the state of the ScaffoldMessenger
  /// widget, which provides the functionality to show snack bars,
  /// banners, and other persistent UI elements.
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static Page<dynamic> fadeTransitionPageBuilder(Widget child, GoRouterState state) {
    log('route => ${state.path}');
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static final goRouter = GoRouter(
    navigatorKey: navKey,
    initialLocation: RtNm.splashScreen,
    routes: [
      ..._authRoutes,
    ],
  );

  static final _authRoutes = [
    GoRoute(
      path: '/',
      // builder: (_, __) => const NowhereScreen(),
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const NowhereScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.splashScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const SplashScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.onboardingScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const OnboardScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.signInWithEmailScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const SignInWithEmailScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.signInWithPhoneScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const SignInWithPhoneScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.signInLoadingScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const SignInLoadingScreen(),
        state,
      ),
    ),

  ];
}
