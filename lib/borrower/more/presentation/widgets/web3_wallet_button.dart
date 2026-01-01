import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/transaction_hash_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../../lender/wallet/presentation/providers/wallet_providers.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../../wallet/data/models/transaction_model.dart';
import '../../../wallet/presentation/controllers/wallet_controller.dart';
import '../../data/models/profile.dart';
import '../providers/more_providers.dart';

class Web3WalletButton extends ConsumerStatefulWidget {
  const Web3WalletButton({super.key, required this.profile});
  final Profile profile;

  @override
  ConsumerState<Web3WalletButton> createState() => _Web3WalletButtonState();
}

class _Web3WalletButtonState extends ConsumerState<Web3WalletButton> {
  @override
  Widget build(BuildContext context) {
    final walletStateAsync = ref.watch(walletControllerProvider);

    return walletStateAsync.when(
      data: (state) {
        if (state.isLoading) {
          return const SizedBox(
            height: 40,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (!state.hasWallet) {
          return Column(
            children: [
              AppPrimaryButton(
                title: 'Create Web3 Wallet',
                onTap: () => _createNewWallet(ref),
              ),
              const VerticalSpace(8),
              TextButton.icon(
                onPressed: () => _importWallet(context, ref),
                icon: const Icon(Icons.upload_file, size: 18),
                label: const Text('Import Existing Wallet'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryLight,
                  textStyle: s12W500(context),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            // Wallet Address Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.cE0E0E0,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet,
                        size: 16,
                        color: AppColors.primaryLight,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Wallet Address',
                        style: s11W400(context).copyWith(
                          color: AppColors.c757575,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Address
                  GestureDetector(
                    onTap: () => _copyAddress(context, state.address),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cF5F5F5,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              state.address ?? '',
                              style:
                                  s12W500(context, fontFamily: interFontFamily)
                                      .copyWith(
                                color: AppColors.c212121,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.copy,
                            size: 16,
                            color: AppColors.primaryLight,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Balance
                  if (state.balance != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Balance',
                          style: s11W400(context).copyWith(
                            color: AppColors.c757575,
                          ),
                        ),
                        Text(
                          state.balance!,
                          style: s14W600(context).copyWith(
                            color: AppColors.c212121,
                          ),
                        ),
                      ],
                    ),
                  ],
                  // Network Badge
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Sepolia Testnet',
                          style: s11W400(context).copyWith(
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _showPrivateKey(context, ref),
                  icon: const Icon(Icons.key),
                  iconSize: 20,
                  color: AppColors.primaryLight,
                  tooltip: 'View Private Key',
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => ref
                      .read(walletControllerProvider.notifier)
                      .refreshBalance(),
                  icon: const Icon(Icons.refresh),
                  iconSize: 20,
                  color: AppColors.primaryLight,
                  tooltip: 'Refresh Balance',
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => _clearWallet(context, ref),
                  icon: const Icon(Icons.delete_outline),
                  iconSize: 20,
                  color: AppColors.errorLight,
                  tooltip: 'Remove Wallet',
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 40,
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, stack) => ElevatedButton(
          onPressed: () {
            ref.invalidate(walletControllerProvider);
          },
          child: Text('Retry')),
    );
  }

  Future<void> _createNewWallet(WidgetRef ref) async {
    try {
      final address =
          await ref.read(walletControllerProvider.notifier).createWallet();
      if (address.isEmpty) {
        return;
      }
      if (widget.profile.wallet != null &&
          widget.profile.wallet!.address != address) {
        await ref.read(walletControllerProvider.notifier).deleteWallet();
        ref.invalidate(profileProvider);
        showErrorDialog(
          context: AppNav.navKey.currentContext!,
          message: 'Wallet does not match with the connected wallet.',
        );
        return;
      }
      if (widget.profile.wallet != null &&
          widget.profile.wallet!.address == address) {
        return;
      }
      if (!mounted) return;
      showLoadingDialog(
        context: AppNav.navKey.currentContext!,
        message: 'Connecting to your wallet.',
      );
      Result<TransactionModel?> result;
      if (widget.profile.userType == 'BORROWER') {
        result = await ref.read(walletRepoProvider).registerBorrowerWallet(
          payload: {
            'borrower': address,
          },
        );
      } else if (widget.profile.userType == 'LENDER') {
        result = await ref.read(walletRepoProvider).registerLenderWallet(
          payload: {
            'lender': address,
          },
        );
      } else {
        result = await ref.read(walletRepoProvider).registerMerchantWallet(
          payload: {
            'merchant': address,
            'name': widget.profile.fullName,
          },
        );
      }
      hideDialog();
      switch (result) {
        case Ok<TransactionModel?>():
          showSuccessDialog(
            context: AppNav.navKey.currentContext!,
            message: 'Wallet connected successfully.',
            otherWidget: TransactionHashText(
              text: result.data?.transactionHash ?? '',
            ),
          );
          ref.invalidate(profileProvider);
          ref.invalidate(availableCreditProvider);
          ref.invalidate(transactionHistoryProvider);
          ref.invalidate(merchantProfileProvider);
          break;
        case Error<TransactionModel?>():
          showErrorDialog(
            context: AppNav.navKey.currentContext!,
            message: result.toString(),
          );
          break;
      }
    } catch (e) {
      if (mounted) {
        showErrorDialog(
          context: context,
          message: 'Failed to create wallet: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _importWallet(BuildContext context, WidgetRef ref) async {
    final TextEditingController privateKeyController = TextEditingController();

    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.upload_file, color: AppColors.primaryLight),
            const SizedBox(width: 8),
            Text('Import Wallet', style: s16W600(context)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your private key to import an existing wallet.',
              style: s12W500(context).copyWith(color: AppColors.c757575),
            ),
            const VerticalSpace(16),
            TextField(
              controller: privateKeyController,
              decoration: InputDecoration(
                hintText: '0x... or private key hex',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.key, size: 20),
              ),
              maxLines: 3,
              style: s12W400(context, fontFamily: 'monospace'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final privateKeyHex = privateKeyController.text.trim();
              Navigator.pop(context); // Close dialog first

              try {
                final address = await ref
                    .read(walletControllerProvider.notifier)
                    .importWallet(privateKeyHex);
                if (address.isEmpty) {
                  showErrorDialog(
                    context: context,
                    message: 'Failed to import wallet',
                  );
                  return;
                }
                if (widget.profile.wallet != null &&
                    widget.profile.wallet!.address != address) {
                  await ref
                      .read(walletControllerProvider.notifier)
                      .deleteWallet();
                  ref.invalidate(profileProvider);
                  showErrorDialog(
                    context: AppNav.navKey.currentContext!,
                    message: 'Wallet does not match with the connected wallet.',
                  );
                  return;
                }
                if (widget.profile.wallet != null &&
                    widget.profile.wallet!.address == address) {
                  return;
                }
                if (!mounted) return;
                showLoadingDialog(
                  context: AppNav.navKey.currentContext!,
                  message: 'Connecting to your wallet.',
                );
                Result<TransactionModel?> result;
                if (widget.profile.userType == 'BORROWER') {
                  result =
                      await ref.read(walletRepoProvider).registerBorrowerWallet(
                    payload: {
                      'borrower': address,
                    },
                  );
                } else if (widget.profile.userType == 'LENDER') {
                  result =
                      await ref.read(walletRepoProvider).registerLenderWallet(
                    payload: {
                      'lender': address,
                    },
                  );
                } else {
                  result =
                      await ref.read(walletRepoProvider).registerMerchantWallet(
                    payload: {
                      'merchant': address,
                      'name': widget.profile.fullName,
                    },
                  );
                }
                hideDialog();
                switch (result) {
                  case Ok<TransactionModel?>():
                    showSuccessDialog(
                      context: AppNav.navKey.currentContext!,
                      message: 'Wallet connected successfully.',
                      otherWidget: TransactionHashText(
                        text: result.data?.transactionHash ?? '',
                      ),
                    );
                    ref.invalidate(profileProvider);
                    ref.invalidate(availableCreditProvider);
                    ref.invalidate(transactionHistoryProvider);
                    ref.invalidate(merchantProfileProvider);
                    break;
                  case Error<TransactionModel?>():
                    showErrorDialog(
                      context: AppNav.navKey.currentContext!,
                      message: result.toString(),
                    );
                    break;
                }
              } catch (e) {
                if (context.mounted) {
                  showErrorDialog(
                    context: context,
                    message: 'Failed to import wallet: ${e.toString()}',
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
            ),
            child: const Text(
              'Import',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPrivateKey(BuildContext context, WidgetRef ref) async {
    final confirm = await showPermissionDialog(
      context: context,
      message:
          'Are you sure you want to view your private key? Never share it with anyone!',
    );

    if (confirm != true) return;

    final privateKey =
        await ref.read(walletControllerProvider.notifier).getPrivateKey();

    if (privateKey == null || !context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: AppColors.errorLight),
            const SizedBox(width: 8),
            Text('Private Key', style: s16W600(context)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KEEP THIS SAFE! Anyone with this key can access your wallet.',
              style: s12W500(context).copyWith(color: AppColors.errorLight),
            ),
            const VerticalSpace(16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.c757575.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: AppColors.c757575.withValues(alpha: 0.3)),
              ),
              child: SelectableText(
                '0x$privateKey',
                style: s12W400(context, fontFamily: 'monospace'),
              ),
            ),
            const VerticalSpace(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: '0x$privateKey'));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Private key copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _copyAddress(BuildContext context, String? address) {
    if (address != null) {
      Clipboard.setData(ClipboardData(text: address));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wallet address copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _clearWallet(BuildContext context, WidgetRef ref) async {
    final confirm = await showPermissionDialog(
      context: context,
      message:
          'Are you sure you want to remove this wallet? Make sure you have backed up your private key!',
    );

    if (confirm != true) return;

    try {
      await ref.read(walletControllerProvider.notifier).deleteWallet();
      if (context.mounted) {
        showSuccessDialog(
          context: context,
          message: 'Wallet removed successfully',
        );
      }
    } catch (e) {
      if (context.mounted) {
        showErrorDialog(
          context: context,
          message: 'Failed to remove wallet: ${e.toString()}',
        );
      }
    }
  }
}
