import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/services/secured_storage_service.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/containers/app_chip.dart';
import '../../../../core/widgets/containers/deem_card.dart';
import '../../../../core/widgets/containers/icon_outer_circle.dart';
import '../../../../core/widgets/errors/when_error_widget.dart';
import '../../../../core/widgets/loaders/when_loading_widget.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../more/presentation/widgets/connect_wallet_button.dart';
import '../../../wallet/business/services/wallet_service.dart';
import '../../../wallet/presentation/providers/wallet_providers.dart';
import '../../data/models/scanned_data.dart';
import '../controllers/payment_controller.dart';
import '../providers/spend_providers.dart';
import '../resources/spends_strings.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final ScannedData scannedData;

  const PaymentScreen({super.key, required this.scannedData});

  @override
  ConsumerState createState() => _SpendAfterScanAmountInputScreenState();
}

class _SpendAfterScanAmountInputScreenState
    extends ConsumerState<PaymentScreen> {
  final _inputController = TextEditingController();
  PaymentController? _controller;

  @override
  void initState() {
    _inputController.text = widget.scannedData.amount?.toStringAsFixed(2) ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        appBar: const PrimaryAppBar(),
        body: Padding(
          padding: const EdgeInsetsGeometry.all(AppValues.paddingMedium),
          child: ref.watch(loggedInUserProvider).when(
            data: (data) {
              if (data == null || data.user.userType != 'BORROWER') {
                AppNav.goRouter.go(RtNm.loginWithEmailScreen);
                return const WhenErrorWidget(
                  error: 'User information not found. Please login again.',
                );
              }
              return ref.watch(appkitModalProvider).when(
                    data: (appKitModal) {
                      _controller ??= PaymentController(
                        context: context,
                        ref: ref,
                        walletService: WalletService(appKitModal),
                      );

                      return ref.watch(availableCreditProvider).when(
                            data: (result) {
                              num availableCreditLimit = 0.0;
                              switch (result) {
                                case Ok<num?>():
                                  availableCreditLimit = result.data ?? 0.0;
                                case Error<num?>():
                              }

                              WidgetsBinding.instance
                                  .addPostFrameCallback((val) {
                                ref.read(inputDetectorProvider.notifier).state =
                                    widget.scannedData.amount
                                            ?.toStringAsFixed(2) ??
                                        '';
                              });

                              return Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          DeemCard(
                                            padding: const EdgeInsets.all(
                                              AppValues.paddingMedium,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  to,
                                                  style: s14W500(context),
                                                ),
                                                const HorizontalSpace(12),
                                                IconOuterCircle(
                                                  size: 40,
                                                  icon: SvgPicture.asset(
                                                    'assets/icons/shopping_bag.svg',
                                                    height: 24,
                                                    width: 24,
                                                  ),
                                                ),
                                                const HorizontalSpace(12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SubTitleText(
                                                        text: widget.scannedData
                                                                .merchantName ??
                                                            'Unknown Merchant',
                                                      ),
                                                      const VerticalSpace(
                                                        AppValues.paddingSmall,
                                                      ),
                                                      Text(
                                                        widget.scannedData
                                                            .getAbstractedAddress,
                                                        style: s11W600(context),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const VerticalSpace(32),
                                          if (appKitModal.isConnected ==
                                                  false &&
                                              widget.scannedData.profile !=
                                                  null)
                                            ConnectWalletButton(
                                              profile:
                                                  widget.scannedData.profile!,
                                            ),
                                          // const SubTitleText(text: enterAmount),
                                          const VerticalSpace(24),
                                          TextFormField(
                                            controller: _inputController,
                                            enabled: false,
                                            style: s54w600(context),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: '0.0',
                                              hintStyle:
                                                  s54w600(context).copyWith(
                                                color: AppColors.c757575,
                                              ),
                                              border: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                vertical:
                                                    AppValues.paddingMedium,
                                                horizontal:
                                                    AppValues.paddingMedium,
                                              ),
                                            ),
                                            onChanged: (val) {
                                              ref
                                                  .read(
                                                    inputDetectorProvider
                                                        .notifier,
                                                  )
                                                  .state = val;
                                            },
                                          ),
                                          const VerticalSpace(12),
                                          Align(
                                            alignment: Alignment.center,
                                            child: AppChip(
                                              text:
                                                  'Available credit ${(availableCreditLimit / oneMillion)} USDC',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Consumer(
                                        builder: (context, ref, _) {
                                          final input =
                                              ref.watch(inputDetectorProvider);

                                          if (input.isEmpty) {
                                            return const AppSecondaryButton(
                                              title: makePayment,
                                              rounded: false,
                                              showBorder: false,
                                              deepColor: false,
                                              titleColor:
                                                  AppColors.surfaceLight,
                                              onTap: null,
                                            );
                                          }

                                          return SafeArea(
                                            child: AppPrimaryButton(
                                              title: makePayment,
                                              onTap: () {
                                                _controller?.doPayment(
                                                  availableCredit:
                                                      availableCreditLimit,
                                                  scannedData:
                                                      widget.scannedData,
                                                  amountStr:
                                                      _inputController.text,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      const VerticalSpace(
                                        AppValues.paddingMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                            error: (error, stck) =>
                                WhenErrorWidget(error: error),
                            loading: () => const WhenLoadingWidget(
                              message: 'Getting your available credit...',
                            ),
                          );
                    },
                    error: (error, stackTrace) {
                      return WhenErrorWidget(error: error);
                    },
                    loading: () => const WhenLoadingWidget(
                      message: 'Getting wallet information...',
                    ),
                  );
            },
            error: (e, st) {
              return WhenErrorWidget(error: e);
            },
            loading: () {
              return const WhenLoadingWidget(
                message: 'Getting user information...',
              );
            },
          ),
        ),
      ),
    );
  }
}
