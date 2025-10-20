import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../borrower/wallet/presentation/providers/wallet_providers.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/decimal_converter.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../deposit/controllers/blockchain_controller.dart';
import '../../../home/presentation/widgets/home_app_bar.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  ReownAppKitModal? appKitModal;
  @override
  void initState() {
    super.initState();
    // Listen to session changes and rebuild UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appKitModal = ref.read(appkitModalProvider).valueOrNull;
      if (appKitModal != null) {
        // Add listeners for connection state changes
        appKitModal?.onModalConnect.subscribe(_onModalConnect);
        appKitModal?.onModalDisconnect.subscribe(_onModalDisconnect);
        appKitModal?.onModalUpdate.subscribe(_onModalUpdate);
      }
    });
  }

  @override
  void dispose() {
    // Clean up listeners
    if (appKitModal != null) {
      appKitModal?.onModalConnect.unsubscribe(_onModalConnect);
      appKitModal?.onModalDisconnect.unsubscribe(_onModalDisconnect);
      appKitModal?.onModalUpdate.unsubscribe(_onModalUpdate);
    }
    super.dispose();
  }

  void _onModalConnect(dynamic event) {
    if (mounted) {
      setState(() {
        // Trigger rebuild when connected
      });
      // Refresh blockchain data
      ref.invalidate(usdcBalanceProvider);
      ref.invalidate(vaultBalanceProvider);
      setState(() {});
    }
  }

  void _onModalDisconnect(dynamic event) {
    if (mounted) {
      setState(() {
        // Trigger rebuild when disconnected
      });
    }
  }

  void _onModalUpdate(dynamic event) {
    if (mounted) {
      setState(() {
        // Trigger rebuild on any modal update
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cF5F5F5,
      appBar: HomeAppBar(
        onGiftTap: () {
          AppNav.goRouter.push(RtNm.rewardsScreen);
        },
        onNotificationTap: () {},
        onProfileTap: () {},
        profileName: 'SH',
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppValues.paddingMedium),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppValues.paddingMedium),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: ref.watch(appkitModalProvider).when(
                    data: (appKitModal) {
                      final isConnected = appKitModal.isConnected;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const MetamaskHeaderWidget(),
                          const VerticalSpace(16),
                          AppKitModalNetworkSelectButton(appKit: appKitModal),
                          const VerticalSpace(8),
                          AppKitModalConnectButton(appKit: appKitModal),
                          const VerticalSpace(8),
                          if (isConnected) ...[
                            AppKitModalAccountButton(appKitModal: appKitModal),
                            const VerticalSpace(24),
                            // USDC Balance Display
                            Consumer(
                              builder: (context, ref, _) {
                                final usdcBalance = ref.watch(
                                  usdcBalanceProvider,
                                );
                                return usdcBalance.when(
                                  data: (balance) => _BalanceDisplay(
                                    label: 'USDC Balance',
                                    amount: balance,
                                  ),
                                  loading: () => const _BalanceDisplay(
                                    label: 'USDC Balance',
                                    amount: null,
                                  ),
                                  error: (error, stack) {
                                    print('USDC Balance Error: $error');
                                    print('Stack: $stack');
                                    return const _BalanceDisplay(
                                      label: 'USDC Balance (Error)',
                                      amount: 0.0,
                                    );
                                  },
                                );
                              },
                            ),
                            // const VerticalSpace(16),
                            // // Vault Balance Display
                            // Consumer(
                            //   builder: (context, ref, _) {
                            //     final vaultBalance = ref.watch(
                            //       vaultBalanceProvider,
                            //     );
                            //     return vaultBalance.when(
                            //       data: (balance) => _BalanceDisplay(
                            //         label: 'Vault Shares',
                            //         amount: balance,
                            //       ),
                            //       loading: () => const _BalanceDisplay(
                            //         label: 'Vault Shares',
                            //         amount: null,
                            //       ),
                            //       error: (error, stack) {
                            //         print('Vault Balance Error: $error');
                            //         print('Stack: $stack');
                            //         return const _BalanceDisplay(
                            //           label: 'Vault Shares (Error)',
                            //           amount: 0.0,
                            //         );
                            //       },
                            //     );
                            //   },
                            // ),
                            const VerticalSpace(24),
                            // Mint USDC Button
                            const _MintUsdcButton(),
                          ],
                        ],
                      );
                    },
                    error: (err, stack) => Center(
                      child: Column(
                        children: [
                          Text('Error: $err'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                ref.invalidate(appkitModalProvider);
                              });
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                    loading: () => Center(
                      child: Skeletonizer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const MetamaskHeaderWidget(),
                            const SizedBox(height: 16),
                            Skeleton.leaf(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                height: 30,
                                width: 150,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Skeleton.leaf(
                              child: Container(
                                height: 40,
                                width: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetamaskHeaderWidget extends StatelessWidget {
  const MetamaskHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SvgPicture.asset('assets/icons/metamask.svg'),
            ),
          ),
        ),
        const SizedBox(height: AppValues.paddingMedium),
        const Text(
          'Metamask',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// Helper widget to display balance
class _BalanceDisplay extends StatelessWidget {
  final String label;
  final double? amount;

  const _BalanceDisplay({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryVariantLight.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.c757575,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (amount == null)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryLight,
              ),
            )
          else
            Text(
              DecimalConverter.formatAmount(amount!),
              style: const TextStyle(
                color: AppColors.c212121,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

// Helper widget for mint USDC button
class _MintUsdcButton extends ConsumerStatefulWidget {
  const _MintUsdcButton();

  @override
  ConsumerState<_MintUsdcButton> createState() => _MintUsdcButtonState();
}

class _MintUsdcButtonState extends ConsumerState<_MintUsdcButton> {
  bool _isMinting = false;

  Future<void> _mintUsdc() async {
    setState(() {
      _isMinting = true;
    });

    try {
      final blockchainService = ref.read(blockchainServiceProvider);
      final txHash = await blockchainService.mintUsdc(1000.0);

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Minting 1000 USDC... Tx: ${txHash.substring(0, 10)}...',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Wait a bit for transaction confirmation
      await Future.delayed(const Duration(seconds: 3));

      // Refresh balances
      if (mounted) {
        ref.invalidate(usdcBalanceProvider);
      }
    } catch (e) {
      if (!mounted) return;
      print('Error minting USDC: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to mint USDC: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isMinting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isMinting ? null : _mintUsdc,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: AppColors.primaryLight.withOpacity(0.5),
        ),
        child: _isMinting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Mint 1000 USDC (Test)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
