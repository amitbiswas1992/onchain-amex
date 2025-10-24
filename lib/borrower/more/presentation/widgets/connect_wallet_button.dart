import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reown_appkit/appkit_modal.dart';

import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/texts/transaction_hash_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../wallet/data/models/transaction_model.dart';
import '../../../wallet/presentation/providers/wallet_providers.dart';
import '../../data/models/profile.dart';
import '../providers/more_providers.dart';

class ConnectWalletButton extends ConsumerStatefulWidget {
  final Profile profile;
  const ConnectWalletButton({super.key, required this.profile});

  @override
  ConsumerState createState() => _ConnectWalletButtonState();
}

class _ConnectWalletButtonState extends ConsumerState<ConnectWalletButton> {
  ReownAppKitModal? appKitModal;

  @override
  void dispose() {
    // appKitModal?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onModalConnect(ModalConnect? event) async {
    if (event == null) return;

    final namespaces = event.session.namespaces;

    /// if wallet has connected previously then no need to send the public address to the server
    if (widget.profile.wallet != null && namespaces != null) {
      late String address;
      namespaces.forEach((network, ns) async {
        for (final acc in ns.accounts) {
          final parts = acc.split(':'); // e.g. ["eip155", "1", "0x123..."]
          if (parts.length >= 3) {
            final chainId = parts[1];
            address = parts[2];
          }
        }
      });
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      if (address != widget.profile.wallet?.address) {
        await ref.read(appkitModalProvider).valueOrNull?.disconnect();
        showErrorDialog(
          context: context,
          message:
              'Connected wallet address does not match with your registered wallet address.',
        );
      }
      return;
    }

    if (namespaces != null) {
      print('namespaces length => ${namespaces.length}');
      namespaces.forEach((network, ns) async {
        for (final acc in ns.accounts) {
          final parts = acc.split(':'); // e.g. ["eip155", "1", "0x123..."]
          if (parts.length >= 3) {
            final chainId = parts[1];
            final address = parts[2];
            await Future.delayed(const Duration(milliseconds: 1000));
            if (!mounted) return;
            showLoadingDialog(
              context: context,
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
              result = await ref.read(walletRepoProvider).registerLenderWallet(
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
            ref.invalidate(profileProvider);
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
                break;
              case Error<TransactionModel?>():
                showErrorDialog(
                  context: AppNav.navKey.currentContext!,
                  message: result.toString(),
                );
                break;
            }

            return;
          }
        }
      });
    }
  }

  Future<void> _onModalDisconnect(ModalDisconnect event) async {}

  Future<void> _onModalError(ModalError event) async {}

  Future<void> _onModalUpdate(ModalConnect event) async {}

  @override
  Widget build(BuildContext context) {
    return ref.watch(appkitModalProvider).when(
          data: (model) {
            appKitModal = model;
            appKitModal?.onModalConnect.subscribe(_onModalConnect);
            appKitModal?.onModalDisconnect.subscribe(_onModalDisconnect);
            appKitModal?.onModalError.subscribe(_onModalError);
            appKitModal?.onModalUpdate.subscribe(_onModalUpdate);

            return AppKitModalConnectButton(
              appKit: model,
              context: context,
            );
          },
          error: (error, stck) => const SizedBox(),
          loading: () => const Center(
            child: Text('Getting wallet info...'),
          ),
        );
  }
}
