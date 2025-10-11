import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reown_appkit/appkit_modal.dart';
import 'package:reown_appkit/modal/appkit_modal_impl.dart';

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

    /// if wallet has connected previously then no need to send the public address to the server
    if (widget.profile.wallet != null) return;

    final namespaces = event.session.namespaces;
    if (namespaces != null) {
      print('namespaces length => ${namespaces.length}');
      namespaces.forEach((network, ns) async {
        for (final acc in ns.accounts) {
          final parts = acc.split(':'); // e.g. ["eip155", "1", "0x123..."]
          if (parts.length >= 3) {
            final chainId = parts[1];
            final address = parts[2];

            showLoadingDialog(context: context, message: 'Connecting to your wallet.');
            final result = await ref.read(walletRepoProvider).connectWallet(
              payload: {
                'borrower': address,
              },
            );
            hideDialog();

            switch (result) {
              case Ok<TransactionModel?>():
                showSuccessDialog(
                  context: AppNav.navKey.currentContext!,
                  message: 'Wallet connected successfully.',
                  otherWidget:
                  TransactionHashText(text: result.data?.transactionHash ?? ''),
                );
                ref.invalidate(profileProvider);
                break;
              case Error<TransactionModel?>():
                showErrorDialog(context: AppNav.navKey.currentContext!, message: result.toString());
                break;
            }

            return;

          }
        }
      });
    }
  }

  Future<void> _onModalDisconnect(ModalDisconnect event) async {

  }

  Future<void> _onModalError(ModalError event) async {

  }

  Future<void> _onModalUpdate(ModalConnect event) async {

  }



  @override
  Widget build(BuildContext context) {
    return ref.watch(appkitModalProvider(null)).when(
      data: (model) {
        appKitModal = model;
        appKitModal?.onModalConnect.subscribe(_onModalConnect);
        appKitModal?.onModalDisconnect.subscribe(_onModalDisconnect);
        appKitModal?.onModalError.subscribe(_onModalError);
        appKitModal?.onModalUpdate.subscribe(_onModalUpdate);

        return AppKitModalConnectButton(appKit: model);
      },
      error: (error, stck) => const SizedBox(),
      loading: () => const SizedBox(),
    );
  }
}
