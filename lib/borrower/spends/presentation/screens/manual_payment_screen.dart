import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/services/secured_storage_service.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/containers/app_chip.dart';
import '../../../../core/widgets/errors/when_error_widget.dart';
import '../../../../core/widgets/loaders/when_loading_widget.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../more/data/models/profile.dart';
import '../../../more/presentation/providers/more_providers.dart';
import '../../../wallet/business/services/wallet_service.dart';
import '../../../wallet/presentation/providers/wallet_providers.dart';
import '../../data/models/scanned_data.dart';
import '../controllers/payment_controller.dart';
import '../resources/spends_strings.dart';

final _manualAmountDetectorProvider = StateProvider<String>((ref) => '');
final _manualWalletAddressProvider = StateProvider<String>((ref) => '');

class ManualPaymentScreen extends ConsumerStatefulWidget {
  const ManualPaymentScreen({super.key});

  @override
  ConsumerState createState() => _ManualPaymentScreenState();
}

class _ManualPaymentScreenState extends ConsumerState<ManualPaymentScreen> {
  final _amountController = TextEditingController();
  final _walletAddressController = TextEditingController();
  final _merchantNameController = TextEditingController();
  PaymentController? _controller;

  @override
  void dispose() {
    _amountController.dispose();
    _walletAddressController.dispose();
    _merchantNameController.dispose();
    super.dispose();
  }

  bool _isValidEthereumAddress(String address) {
    // Basic Ethereum address validation (starts with 0x and has 42 characters)
    final regex = RegExp(r'^0x[a-fA-F0-9]{40}$');
    return regex.hasMatch(address);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppValues.paddingMedium),
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

                      return ref.watch(profileProvider).when(
                            data: (profileResult) {
                              Profile? profile;
                              switch (profileResult) {
                                case Ok<Profile?>():
                                  profile = profileResult.data;
                                case Error<Profile?>():
                              }

                              return ref.watch(availableCreditProvider).when(
                                    data: (result) {
                                      num availableCreditLimit = 0.0;
                                      switch (result) {
                                        case Ok<num?>():
                                          availableCreditLimit =
                                              result.data ?? 0.0;
                                        case Error<num?>():
                                      }

                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (appKitModal.isConnected ==
                                                          false &&
                                                      profile != null)
                                                    const SubTitleText(
                                                      text:
                                                          'Recipient Wallet Address',
                                                    ),
                                                  const VerticalSpace(12),
                                                  TextFormField(
                                                    controller:
                                                        _walletAddressController,
                                                    style: s14W500(context),
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration: InputDecoration(
                                                      hintText: '0x...',
                                                      hintStyle:
                                                          s14W500(context)
                                                              .copyWith(
                                                        color:
                                                            AppColors.c757575,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          12,
                                                        ),
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              AppColors.c757575,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          12,
                                                        ),
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              AppColors.c757575,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          12,
                                                        ),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: AppColors
                                                              .primaryLight,
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        vertical: AppValues
                                                            .paddingMedium,
                                                        horizontal: AppValues
                                                            .paddingMedium,
                                                      ),
                                                    ),
                                                    onChanged: (val) {
                                                      ref
                                                          .read(
                                                            _manualWalletAddressProvider
                                                                .notifier,
                                                          )
                                                          .state = val;
                                                    },
                                                  ),
                                                  const VerticalSpace(24),
                                                  TextFormField(
                                                    controller:
                                                        _amountController,
                                                    style: s32W600(context),
                                                    textAlign: TextAlign.center,
                                                    keyboardType:
                                                        const TextInputType
                                                            .numberWithOptions(
                                                      decimal: true,
                                                    ),
                                                    decoration: InputDecoration(
                                                      hintText: '0.0',
                                                      hintStyle:
                                                          s32W600(context)
                                                              .copyWith(
                                                        color:
                                                            AppColors.c757575,
                                                      ),
                                                      border: InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        vertical: AppValues
                                                            .paddingMedium,
                                                        horizontal: AppValues
                                                            .paddingMedium,
                                                      ),
                                                    ),
                                                    onChanged: (val) {
                                                      ref
                                                          .read(
                                                            _manualAmountDetectorProvider
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
                                                  final amount = ref.watch(
                                                    _manualAmountDetectorProvider,
                                                  );
                                                  final walletAddress =
                                                      ref.watch(
                                                    _manualWalletAddressProvider,
                                                  );

                                                  final isValid = amount
                                                          .isNotEmpty &&
                                                      walletAddress
                                                          .isNotEmpty &&
                                                      _isValidEthereumAddress(
                                                        walletAddress,
                                                      );

                                                  if (!isValid) {
                                                    return const AppSecondaryButton(
                                                      title: makePayment,
                                                      rounded: false,
                                                      showBorder: false,
                                                      deepColor: false,
                                                      titleColor: AppColors
                                                          .surfaceLight,
                                                      onTap: null,
                                                    );
                                                  }

                                                  return AppPrimaryButton(
                                                    title: makePayment,
                                                    onTap: () {
                                                      _controller?.doPayment(
                                                        availableCredit:
                                                            availableCreditLimit,
                                                        scannedData:
                                                            ScannedData(
                                                          amount:
                                                              double.tryParse(
                                                            _amountController
                                                                .text,
                                                          ),
                                                          walletAddress:
                                                              _walletAddressController
                                                                  .text,
                                                          merchantName:
                                                              _merchantNameController
                                                                      .text
                                                                      .isEmpty
                                                                  ? 'Manual Payment'
                                                                  : _merchantNameController
                                                                      .text,
                                                          profile: profile,
                                                        ),
                                                        amountStr:
                                                            _amountController
                                                                .text,
                                                      );
                                                    },
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
                                      message:
                                          'Getting your available credit...',
                                    ),
                                  );
                            },
                            error: (error, stackTrace) {
                              return WhenErrorWidget(error: error);
                            },
                            loading: () => const WhenLoadingWidget(
                              message: 'Getting profile information...',
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
                  );
                },
                error: (error, stackTrace) {
                  return WhenErrorWidget(error: error);
                },
                loading: () => const WhenLoadingWidget(
                  message: 'Getting user information...',
                ),
              ),
        ),
      ),
    );
  }
}
