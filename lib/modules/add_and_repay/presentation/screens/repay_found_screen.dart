import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../core/extensions/big_int_extensions.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/containers/app_chip.dart';
import '../../../../core/widgets/containers/deem_card.dart';
import '../../../../core/widgets/containers/icon_outer_circle.dart';
import '../../../../core/widgets/dividers/app_divider.dart';
import '../../../../core/widgets/loaders/when_loading_widget.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../home/presentation/resources/home_strings.dart';
import '../../../more/data/models/profile.dart';
import '../../../more/presentation/widgets/connect_wallet_button.dart';
import '../../../spends/data/models/payment_success_extra.dart';
import '../../../spends/presentation/providers/spend_providers.dart';
import '../../../spends/presentation/resources/spends_strings.dart';
import '../../../wallet/business/services/wallet_service.dart';
import '../../../wallet/data/models/borrower_profile.dart';
import '../../../wallet/presentation/providers/wallet_providers.dart';
import '../../../wallet/presentation/widgets/metamask_header_widget.dart';
import '../../../wallet/presentation/widgets/mint_usdc_button.dart';
import '../controllers/add_and_repay_controller.dart';

class RepayFoundScreen extends ConsumerStatefulWidget {
  final BorrowerProfile borrowerProfile;

  const RepayFoundScreen({super.key, required this.borrowerProfile});

  @override
  ConsumerState createState() => _ReplayFoundScreenState();
}

class _ReplayFoundScreenState extends ConsumerState<RepayFoundScreen> {
  AddAndRepayController? _controller;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        appBar: const PrimaryAppBar(
          title: repay,
        ),
        body: Padding(
          padding: const EdgeInsetsGeometry.all(AppValues.paddingMedium),
          child: ref.watch(appkitModalProvider(RtNm.replayFoundScreen)).when(
            data: (appKitModal) {
              _controller ??= AddAndRepayController(
                context: context,
                ref: ref,
                walletService: WalletService(appKitModal),
              );

              if (appKitModal.isConnected == false) {
                return  Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Wallet not connected'),
                      const VerticalSpace(AppValues.paddingMedium),
                      AppPrimaryButton(title: 'Go to profile to connect wallet.', onTap: () {
                        AppNav.goRouter.go(RtNm.moreScreen);
                        ref.read(bottomNavSelectedIndexProvider.notifier).state = 4;
                      }),
                    ],
                  ),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const VerticalSpace(AppValues.paddingSmall),
                          // Row(
                          //   children: [
                          //     const HorizontalSpace(12),
                          //     IconOuterCircle(
                          //       size: 40,
                          //       icon: SvgPicture.asset(
                          //         'assets/icons/visa.svg',
                          //         height: 24,
                          //         width: 24,
                          //       ),
                          //     ),
                          //     const HorizontalSpace(12),
                          //     Expanded(
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const SubTitleText(text: 'Starbucks'),
                          //           const VerticalSpace(AppValues.paddingSmall),
                          //           Text(
                          //             '0123....................................3456',
                          //             style: s11W600(context),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     InkWell(
                          //       onTap: () {},
                          //       child: Container(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: AppValues.paddingMedium - 4,
                          //           vertical: 4,
                          //         ),
                          //         decoration: BoxDecoration(
                          //           color: AppColors.primaryLight,
                          //           borderRadius: BorderRadius.circular(56),
                          //         ),
                          //         alignment: Alignment.center,
                          //         child: Text(
                          //           change,
                          //           style: s14W500(context).copyWith(
                          //             color: Colors.white,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     const HorizontalSpace(12),
                          //   ],
                          // ),
                          const MetamaskHeaderWidget(),
                          // ConnectWalletButton(profile: widget.profile),
                          const VerticalSpace(AppValues.paddingMedium),
                          MintUsdcButton(walletService: WalletService(appKitModal)),
                          const VerticalSpace(12),
                          const AppDivider(),
                          const VerticalSpace(32),
                          const SubTitleText(text: enterAmount),
                          const VerticalSpace(AppValues.paddingMedium),
                          TextFormField(
                            controller: _amountController,
                            style: s54w600(context),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '0.0',
                              hintStyle: s54w600(context).copyWith(color: AppColors.c757575),
                              border: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: AppValues.paddingMedium,
                                horizontal: AppValues.paddingMedium,
                              ),
                            ),
                            onChanged: (val) {
                              ref.read(inputDetectorProvider.notifier).state = val ?? '';
                            },
                          ),
                          const VerticalSpace(4),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     ...['1/4', '2/4', '3/4', 'Full'].map((e) {
                          //       return Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 4,
                          //         ),
                          //         child: AppChip(
                          //           text: e,
                          //         ),
                          //       );
                          //     }),
                          //   ],
                          // ),
                          const VerticalSpace(32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.info_outline, size: 12),
                              const HorizontalSpace(4),
                              Text(
                                'Current outstanding',
                                style: s12W500(context),
                              ),
                              Text(
                                ' ${widget.borrowerProfile.outstandingDebt?.toBigInt().dividedByMillion().toStringAsFixed(2) ?? '0'}',
                                style: s12W500(context).copyWith(color: AppColors.primaryVariantLight),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),Padding(
                    padding: const EdgeInsets.only(bottom: AppValues.paddingMedium),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final input = ref.watch(inputDetectorProvider);

                        if (input.isEmpty) {
                          return AppSecondaryButton(
                            title: makePayment,
                            rounded: false,
                            showBorder: false,
                            deepColor: false,
                            titleColor: AppColors.surfaceLight,
                            onTap: () {},
                          );
                        }

                        return AppPrimaryButton(
                          title: makePayment,
                          onTap: () {
                            log('repay');
                            print  ('repay');
                            _controller?.repay(_amountController.text.trim(), widget.borrowerProfile);
                            // AppNav.goRouter.push(
                            //   RtNm.paymentSuccessScreen,
                            //   extra: PaymentSuccessExtra.dummay(ref: ref),
                            // );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            error: (error, stck) => const SizedBox(),
            loading: () => const WhenLoadingWidget(message: 'Getting wallet ready....'),
          ),
        ),
      ),
    );
  }
}
