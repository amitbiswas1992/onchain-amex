import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_secrets.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/texts/transaction_hash_text.dart';
import '../../../../infrastructure/network/result.dart';
import '../../business/repository/wallet_repo_interface.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/wallet_info.dart';

class WalletController {
  final BuildContext context;
  final WidgetRef ref;
  final WalletRepoInterface walletRepo;

  ReownAppKitModal? _appKitModal;

  WalletController({
    required this.context,
    required this.ref,
    required this.walletRepo,
  });

  void dispose() {
    _appKitModal?.dispose();
  }

  Future<WalletInfo?> _getWalletPublicAddress() async {
    try {
      // create the modal instance
      _appKitModal ??= ReownAppKitModal(
        context: context,
        projectId: reownProjectId,
        logLevel: LogLevel.error,
        metadata: const PairingMetadata(
          name: 'TMRW',
          description: 'TMRW App',
          redirect: Redirect(
            native: 'tmrw://',
            linkMode: false,
          ),
        ),
      );

      final completer = Completer<WalletInfo?>();

      _appKitModal?.onModalConnect.subscribe((ModalConnect? event) {
        if (event == null) return;

        final namespaces = event.session.namespaces;
        if (namespaces != null) {
          namespaces.forEach((network, ns) {
            for (final acc in ns.accounts) {
              final parts = acc.split(':'); // e.g. ["eip155", "1", "0x123..."]
              if (parts.length >= 3) {
                final chainId = parts[1];
                final address = parts[2];

                final networkName = getNetworkName(chainId);

                if (!completer.isCompleted) {
                  completer.complete(
                    WalletInfo(
                      publicAddress: address,
                      network: networkName, // human readable
                      walletName: "Unknown", // not exposed by SDK
                    ),
                  );
                }
              }
            }
          });
        }
      });


      _appKitModal?.onModalError.subscribe((error) {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      });

      _appKitModal?.onModalDisconnect.subscribe((_) {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      });

      await _appKitModal?.init();

      // open modal UI to connect wallet
      await _appKitModal?.openModalView();

      // if (completer.isCompleted == false) {
      //   completer.complete(null);
      // }

      return completer.future;
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }

    return null;
  }

  static const Map<String, String> chainNames = {
    '1': 'Ethereum Mainnet',
    '3': 'Ropsten Testnet',
    '4': 'Rinkeby Testnet',
    '5': 'Goerli Testnet',
    '42': 'Kovan Testnet',
    '56': 'Binance Smart Chain',
    '97': 'BSC Testnet',
    '137': 'Polygon Mainnet',
    '80001': 'Polygon Mumbai Testnet',
    '43114': 'Avalanche C-Chain',
    '43113': 'Avalanche Fuji Testnet',
    '42161': 'Arbitrum One',
    '421613': 'Arbitrum Goerli',
    '10': 'Optimism Mainnet',
    '420': 'Optimism Goerli',
  };

  String getNetworkName(String chainId) {
    return chainNames[chainId] ?? 'Unknown Network ($chainId)';
  }

  Future<void> connectWalletToServer() async {
    showLoadingDialog(context: context, message: 'Getting things ready...');
    final publicAddress = await _getWalletPublicAddress();
    hideDialog();
    if (publicAddress == null) {
      // showErrorDialog(context: context, message: 'Unable to get wallet information');
      return;
    }

    showLoadingDialog(context: context, message: 'Connecting to your wallet.');
    final result = await walletRepo.connectWallet(
      payload: {
        'borrower': publicAddress.publicAddress,
      },
    );
    hideDialog();

    switch (result) {
      case Ok<TransactionModel?>():
        showSuccessDialog(
          context: context,
          message: 'Wallet connected successfully.',
          otherWidget: TransactionHashText(text: result.data?.transactionHash ?? ''),
        );
        break;
      case Error<TransactionModel?>():
        showErrorDialog(context: context, message: result.toString());
        break;
    }
  }
}
