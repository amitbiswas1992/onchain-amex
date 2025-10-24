import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../borrower/add_and_repay/presentation/screens/add_found_screen.dart';
import '../../borrower/add_and_repay/presentation/screens/repay_found_screen.dart';
import '../../borrower/cards/data/models/choose_card_extra.dart';
import '../../borrower/cards/presentation/screens/cards_screen.dart';
import '../../borrower/cards/presentation/screens/choose_card_details_screen.dart';
import '../../borrower/cards/presentation/screens/choose_card_info_input_screen.dart';
import '../../borrower/cards/presentation/screens/choose_card_screen.dart';
import '../../borrower/cards/presentation/screens/order_card_payment_method_screen.dart';
import '../../borrower/delete_account/presentation/screens/delete_account_screen.dart';
import '../../borrower/home/presentation/screens/home_screen.dart';
import '../../borrower/home/presentation/screens/shell_screen.dart';
import '../../borrower/invite_friend/presentation/screens/invitation_code_input_screen.dart';
import '../../borrower/invite_friend/presentation/screens/invitation_success_screen.dart';
import '../../borrower/invite_friend/presentation/screens/invite_friend_screen.dart';
import '../../borrower/kyc/presentation/screens/id_check_kyc_options_screen.dart';
import '../../borrower/kyc/presentation/screens/kyc_screen.dart';
import '../../borrower/kyc/presentation/screens/kyc_success_screen.dart';
import '../../borrower/more/data/models/profile.dart';
import '../../borrower/more/presentation/screens/change_email_screen.dart';
import '../../borrower/more/presentation/screens/change_phone_screen.dart';
import '../../borrower/more/presentation/screens/language_and_appearance_screen.dart';
import '../../borrower/more/presentation/screens/manage_devices_screen.dart';
import '../../borrower/more/presentation/screens/more_screen.dart';
import '../../borrower/more/presentation/screens/notification_settings_screen.dart';
import '../../borrower/more/presentation/screens/personal_details_screen.dart';
import '../../borrower/more/presentation/screens/personal_information_screen.dart';
import '../../borrower/more/presentation/screens/security_privacy_screen.dart';
import '../../borrower/onboard/presentation/screens/onboard_screen.dart';
import '../../borrower/payment_methods/presentation/screens/add_a_card_screen.dart';
import '../../borrower/payment_methods/presentation/screens/bank_location_select_screen.dart';
import '../../borrower/payment_methods/presentation/screens/connect_bank_ac_desclaimer_screen.dart';
import '../../borrower/payment_methods/presentation/screens/connected_bank_accounts_screen.dart';
import '../../borrower/payment_methods/presentation/screens/payment_methods_screen.dart';
import '../../borrower/payment_methods/presentation/screens/saved_cards_screen.dart';
import '../../borrower/rewards/presentation/screens/rewards_screen.dart';
import '../../borrower/signin/presentation/screens/forgot_password_screen.dart';
import '../../borrower/signin/presentation/screens/login_with_email_screen.dart';
import '../../borrower/signin/presentation/screens/login_with_phone_screen.dart';
import '../../borrower/signin/presentation/screens/otp_input_screen.dart';
import '../../borrower/signin/presentation/screens/register_with_email_screen.dart';
import '../../borrower/signin/presentation/screens/register_with_phone_screen.dart';
import '../../borrower/signin/presentation/screens/reset_password_screen.dart';
import '../../borrower/signin/presentation/screens/sign_in_loading_screen.dart';
import '../../borrower/signin/presentation/screens/user_info_input_screen.dart';
import '../../borrower/spends/data/models/payment_success_extra.dart';
import '../../borrower/spends/data/models/scanned_data.dart';
import '../../borrower/spends/presentation/screens/payment_screen.dart';
import '../../borrower/spends/presentation/screens/payment_success_screen.dart';
import '../../borrower/spends/presentation/screens/qr_code_scanner_screen.dart';
import '../../borrower/spends/presentation/screens/spends_screen.dart';
import '../../borrower/spends/presentation/widgets/scan_and_pay_page.dart';
import '../../borrower/splash/presentation/screens/nowhere_screen.dart';
import '../../borrower/splash/presentation/screens/splash_screen.dart';
import '../../borrower/transactions/presentation/screens/transactions_screen.dart';
import '../../borrower/wallet/data/models/borrower_profile.dart';
import '../../core/widgets/success_screen.dart';
import '../../lender/deposit/presentation/screens/deposit_amount_screen.dart';
import '../../lender/deposit/presentation/screens/deposit_confirmation_screen.dart';
import '../../lender/deposit/presentation/screens/withdraw_amount_screen.dart';
import '../../lender/home/presentation/screens/lender_home_screen.dart';
import '../../lender/home/presentation/screens/lender_shell_screen.dart';
import '../../lender/wallet/presentation/screens/wallet_screen.dart';
import '../../merchant/home/presentation/merchant_home_screen.dart';
import '../../merchant/home/presentation/merchant_withdraw_screen.dart';
import '../../merchant/merchant_transactions/presentation/screens/merchant_transactions_screen.dart';
import '../../merchant/navbar/navigation_screen.dart';
import '../../merchant/payment/presentation/screens/pos_payment_screen.dart';
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
  static final lenderShellNavKey = GlobalKey<NavigatorState>();
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
    observers: [routeObserver],
    initialLocation:
        kDebugMode == false ? RtNm.splashScreen : RtNm.splashScreen,
    routes: [
      _borrowerShellRoutes,
      _lenderShellRoutes,
      _merchantRoutes,
      ..._authRoutes,
      ..._inviteFriendRoutes,
      ..._spendRoutes,
      ..._addAndRepayFoundRoutes,
      ..._cardsRoutes,
      ..._rewardsRoutes,
      ..._moreRoutes,
      ..._depositRoutes,
    ],
  );

  static final _moreRoutes = [
    GoRoute(
      path: RtNm.personalDetailsScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        PersonalDetailsScreen(profile: state.extra as Profile),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.personalInformationScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        PersonalInformationScreen(profile: state.extra as Profile),
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
    GoRoute(
      path: RtNm.connectedBankAccountsScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const ConnectedBankAccountsScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.bankLocationSelectScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const BankLocationSelectScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.connectBankAcDisclaimerScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const ConnectBankAcDisclaimerScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.deleteAccountScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        DeleteAccountScreen(profile: state.extra as Profile),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.manageDevicesScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const ManageDevicesScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.kycScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const KycScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.idCheckKycOptionsScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const IdCheckKycOptionsScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.kycSuccessScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const KycSuccessScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.languageAndAppearanceScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const LanguageAndAppearanceScreen(),
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
      path: RtNm.registerWithEmailScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const RegisterWithEmailScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.registerWithPhoneScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const RegisterWithPhoneScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.loginWithEmailScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const LoginWithEmailScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.forgotPasswordScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const ForgotPasswordScreen(),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.resetPasswordScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        // allow passing email and otp as extra map
        ResetPasswordScreen(
          email: (state.extra as Map<String, dynamic>?)?['email'] as String?,
        ),
        state,
      ),
    ),
    GoRoute(
      path: RtNm.loginWithPhoneScreen,
      pageBuilder: (context, state) => fadeTransitionPageBuilder(
        const LogInWithPhoneScreen(),
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
      pageBuilder: (context, state) {
        final extraMap = state.extra as Map<String, dynamic>;
        return fadeTransitionPageBuilder(
          OtpInputScreen(
            emailOrPhone: extraMap['emailOrPhone'],
            isEmail: extraMap['isEmail'],
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: RtNm.userInfoInputScreen,
      pageBuilder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return fadeTransitionPageBuilder(
          UserInfoInputScreen(
            email: extras['email'],
            password: extras['password'],
          ),
          state,
        );
      },
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
      path: RtNm.paymentScreen,
      pageBuilder: (context, state) {
        if (state.uri.queryParameters.containsKey('data')) {
          try {
            final dataStr = utf8
                .decode(base64Url.decode(state.uri.queryParameters['data']!));
            dev.log('data => ${dataStr.runtimeType} => $dataStr');
            final scannedData = ScannedData.fromJson(jsonDecode(dataStr), null);
            return fadeTransitionPageBuilder(
              PaymentScreen(scannedData: scannedData),
              state,
            );
          } catch (error, stck) {
            debugPrint(error.toString());
            debugPrint(stck.toString());

            return fadeTransitionPageBuilder(
              const ScanAndPayPage(),
              state,
            );
          }
        }
        return fadeTransitionPageBuilder(
          PaymentScreen(scannedData: state.extra as ScannedData),
          state,
        );
      },
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
        RepayFoundScreen(borrowerProfile: state.extra as BorrowerProfile),
        state,
      ),
    ),
  ];
  static final _depositRoutes = [
    GoRoute(
      path: RtNm.lenderDepositAmountScreen,
      pageBuilder: (context, state) =>
          fadeTransitionPageBuilder(const DepositAmountScreen(), state),
    ),
    GoRoute(
      path: RtNm.lenderDepositConfirmationScreen,
      pageBuilder: (context, state) =>
          fadeTransitionPageBuilder(const DepositConfirmationScreen(), state),
    ),
    GoRoute(
      path: RtNm.lenderWithdrawAmountScreen,
      pageBuilder: (context, state) =>
          fadeTransitionPageBuilder(const WithdrawAmountScreen(), state),
    ),
    GoRoute(
      path: RtNm.successScreen,
      pageBuilder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;
        return fadeTransitionPageBuilder(
          SuccessScreen(
            title: extra['title'] ?? 'Success',
            subtitle: extra['subtitle'] ??
                'The operation was completed successfully.',
            txHash: extra['txHash'],
          ),
          state,
        );
      },
    ),
  ];

  static final _merchantRoutes = StatefulShellRoute.indexedStack(
    pageBuilder: (context, state, navigationShell) => MaterialPage(
      child: ScaffoldWithNestedNavigation(navigationShell: navigationShell),
    ),
    branches: [
      StatefulShellBranch(
        // navigatorKey: _settingsNavigatorKey,
        routes: [
          GoRoute(
            path: RtNm.merchantHomeScreen,
            name: RtNm.merchantHomeScreen,
            pageBuilder: (context, state) =>
                fadeTransitionPageBuilder(const MerchantHomeScreen(), state),
            routes: [
              GoRoute(
                path: RtNm.merchantWithdrawScreen,
                name: RtNm.merchantWithdrawScreen,
                parentNavigatorKey: navKey,
                pageBuilder: (context, state) => fadeTransitionPageBuilder(
                  const MerchantWithdrawScreen(),
                  state,
                ),
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        // navigatorKey: _settingsNavigatorKey,
        routes: [
          GoRoute(
            path: RtNm.merchantPaymentScreen,
            name: RtNm.merchantPaymentScreen,
            pageBuilder: (context, state) =>
                fadeTransitionPageBuilder(const PosPaymentScreen(), state),
          ),
        ],
      ),
      StatefulShellBranch(
        // navigatorKey: _settingsNavigatorKey,
        routes: [
          GoRoute(
            path: RtNm.merchantTransactionsScreen,
            name: RtNm.merchantTransactionsScreen,
            pageBuilder: (context, state) => fadeTransitionPageBuilder(
              const MerchantTransactionsScreen(),
              state,
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        // navigatorKey: _settingsNavigatorKey,
        routes: [
          GoRoute(
            path: RtNm.merchantMoreScreen,
            name: RtNm.merchantMoreScreen,
            pageBuilder: (context, state) =>
                fadeTransitionPageBuilder(const MoreScreen(), state),
          ),
        ],
      ),
    ],
  );

  static final _lenderShellRoutes = ShellRoute(
    navigatorKey: lenderShellNavKey,
    builder: (context, state, child) {
      return LenderShellScreen(child: child);
    },
    routes: [
      GoRoute(
        path: RtNm.lenderHomeScreen,
        pageBuilder: (context, state) =>
            fadeTransitionPageBuilder(const LenderHomeScreen(), state),
        routes: [
          GoRoute(
            path: RtNm.lenderWalletScreen,
            name: RtNm.lenderWalletScreen,
            pageBuilder: (context, state) =>
                fadeTransitionPageBuilder(const WalletScreen(), state),
          ),
        ],
      ),
      GoRoute(
        path: RtNm.lenderMoreScreen,
        pageBuilder: (context, state) =>
            fadeTransitionPageBuilder(const MoreScreen(), state),
      ),
    ],
  );

  static final _borrowerShellRoutes = ShellRoute(
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
