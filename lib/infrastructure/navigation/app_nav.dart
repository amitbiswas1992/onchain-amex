import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../modules/add_and_repay/presentation/screens/add_found_screen.dart';
import '../../modules/add_and_repay/presentation/screens/replay_found_screen.dart';
import '../../modules/cards/data/models/choose_card_extra.dart';
import '../../modules/cards/presentation/screens/cards_screen.dart';
import '../../modules/cards/presentation/screens/choose_card_details_screen.dart';
import '../../modules/cards/presentation/screens/choose_card_info_input_screen.dart';
import '../../modules/cards/presentation/screens/choose_card_screen.dart';
import '../../modules/cards/presentation/screens/order_card_payment_method_screen.dart';
import '../../modules/home/presentation/screens/home_screen.dart';
import '../../modules/home/presentation/screens/shell_screen.dart';
import '../../modules/invite_friend/presentation/screens/invitation_code_input_screen.dart';
import '../../modules/invite_friend/presentation/screens/invitation_success_screen.dart';
import '../../modules/invite_friend/presentation/screens/invite_friend_screen.dart';
import '../../modules/more/presentation/screens/change_email_screen.dart';
import '../../modules/more/presentation/screens/change_phone_screen.dart';
import '../../modules/more/presentation/screens/more_screen.dart';
import '../../modules/more/presentation/screens/notification_settings_screen.dart';
import '../../modules/more/presentation/screens/personal_details_screen.dart';
import '../../modules/more/presentation/screens/personal_information_screen.dart';
import '../../modules/more/presentation/screens/security_privacy_screen.dart';
import '../../modules/onboard/presentation/screens/onboard_screen.dart';
import '../../modules/payment_methods/presentation/screens/add_a_card_screen.dart';
import '../../modules/payment_methods/presentation/screens/payment_methods_screen.dart';
import '../../modules/payment_methods/presentation/screens/saved_cards_screen.dart';
import '../../modules/rewards/presentation/screens/rewards_screen.dart';
import '../../modules/signin/presentation/screens/otp_input_screen.dart';
import '../../modules/signin/presentation/screens/sign_in_loading_screen.dart';
import '../../modules/signin/presentation/screens/sign_in_with_email_screen.dart';
import '../../modules/signin/presentation/screens/sign_in_with_phone_screen.dart';
import '../../modules/signin/presentation/screens/user_info_input_screen.dart';
import '../../modules/spends/data/models/payment_success_extra.dart';
import '../../modules/spends/presentation/screens/payment_success_screen.dart';
import '../../modules/spends/presentation/screens/qr_code_scanner_screen.dart';
import '../../modules/spends/presentation/screens/spend_after_scan_amount_input_screen.dart';
import '../../modules/spends/presentation/screens/spends_screen.dart';
import '../../modules/splash/presentation/screens/nowhere_screen.dart';
import '../../modules/splash/presentation/screens/splash_screen.dart';
import '../../modules/transactions/presentation/screens/transactions_screen.dart';
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

  static Page<dynamic> fadeTransitionPageBuilder(
    Widget child,
    GoRouterState state,
  ) {
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
    initialLocation: kDebugMode == false ? RtNm.splashScreen : RtNm.homeScreen,
    routes: [
      _shellRoutes,
      ..._authRoutes,
      ..._inviteFriendRoutes,
      ..._spendRoutes,
      ..._addAndRepayFoundRoutes,
      ..._cardsRoutes,
      ..._rewardsRoutes,
      ..._moreRoutes,
    ],
  );

  static final _moreRoutes = [
    GoRoute(
      path: RtNm.personalDetailsScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const PersonalDetailsScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.personalInformationScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const PersonalInformationScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.changeEmailScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const ChangeEmailScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.changePhoneScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const ChangePhoneScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.securityPrivacyScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const SecurityPrivacyScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.notificationSettingsScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const NotificationSettingsScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.paymentMethodsScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const PaymentMethodsScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.savedCardsScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const SavedCardsScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.addACardScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const AddACardScreen(),
        state,
      ),
    ),
  ];

  static final _rewardsRoutes = [
    GoRoute(
      path: RtNm.rewardsScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const RewardsScreen(),
        state,
      ),
    ),
  ];

  static final _cardsRoutes = [
    GoRoute(
      path: RtNm.chooseCardScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const ChooseCardScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.chooseCardDetailsScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        ChooseCardDetailsScreen(extra: state.extra as ChooseCardExtra),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.chooseCardInfoInputScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const ChooseCardInfoInputScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.orderCardPaymentMethodScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const OrderCardPaymentMethodScreen(),
        state,
      ),
    ),
  ];

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
    GoRoute(
      path: RtNm.otpInputScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const OtpInputScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.userInfoInputScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const UserInfoInputScreen(),
        state,
      ),
    ),
  ];

  static final _inviteFriendRoutes = [
    GoRoute(
      path: RtNm.inviteFriendScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const InviteFriendScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.inviteCodeInputScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const InvitationCodeInputScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.invitationSuccessScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const InvitationSuccessScreen(),
        state,
      ),
    ),
  ];

  static final _spendRoutes = [
    GoRoute(
      path: RtNm.qrCodeScannerScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const QrCodeScannerScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.spendAfterScanAmountInputScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const SpendAfterScanAmountInputScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.paymentSuccessScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        PaymentSuccessScreen(extra: state.extra as PaymentSuccessExtra?),
        state,
      ),
    ),
  ];

  static final _addAndRepayFoundRoutes = [
    GoRoute(
      path: RtNm.addFoundScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const AddFoundScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.replayFoundScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const ReplayFoundScreen(),
        state,
      ),
    ),
  ];

  static final _shellRoutes = ShellRoute(
    navigatorKey: shellNavKey,
    builder: (context, state, child) {
      return ShellScreen(child: child);
    },
    routes: [
      GoRoute(
        path: RtNm.homeScreen,
        // builder: (_, __) => const HomeScreen(),
        pageBuilder: (context, state) => fadeTransitionPageBuilder(
          const HomeScreen(),
          state,
        ),
      ),
      GoRoute(
        path: RtNm.cardsScreen,
        // builder: (_, __) => const EssentialsScreen(),
        pageBuilder: (context, state) => fadeTransitionPageBuilder(
          const CardsScreen(),
          state,
        ),
      ),
      GoRoute(
        path: RtNm.spendScreen,
        // builder: (_, __) => const InboxScreen(),
        pageBuilder: (context, state) => fadeTransitionPageBuilder(
          const SpendsScreen(),
          state,
        ),
      ),
      GoRoute(
        path: RtNm.transactionsScreen,
        // builder: (_, __) => const ActivityScreen(),
        pageBuilder: (context, state) => fadeTransitionPageBuilder(
          const TransactionsScreen(),
          state,
        ),
      ),
      GoRoute(
        path: RtNm.moreScreen,
        // builder: (_, __) => const SettingsScreen(),
        pageBuilder: (context, state) => fadeTransitionPageBuilder(
          const MoreScreen(),
          state,
        ),
      ),
    ],
  );
}
