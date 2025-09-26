import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../core/resources/app_secrets.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../infrastructure/network/result.dart';
import '../../business/repository/wallet_repo_interface.dart';

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

  Future<String?> _getWalletPublicAddress() async {
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

      final completer = Completer<String?>();

      _appKitModal?.onModalConnect.subscribe((ModalConnect? event) {
        if (event == null) return;

        // Extract accounts from namespaces
        final namespaces = event.session.namespaces;
        if (namespaces != null) {
          for (final ns in namespaces.values) {
            for (final acc in ns.accounts) {
              final parts = acc.split(':');
              final address = parts.last;
              if (!completer.isCompleted) {
                completer.complete(address);
              }
            }
          }
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

  Future<void> connectWalletToServer() async {
    showLoadingDialog(context: context, message: 'Getting things ready...');
    final publicAddress = await _getWalletPublicAddress();
    hideDialog();
    if (publicAddress == null) {
      showErrorDialog(context: context, message: 'Unable to get wallet information');
      return;
    }

    showLoadingDialog(context: context, message: 'Connecting to your wallet.');
    final result = await walletRepo.connectWallet(
      payload: {
        'borrower': publicAddress,
      },
    );
    hideDialog();

    switch (result) {
      case Ok():
        showSuccessDialog(context: context, message: result.message);
        break;
      case Error():
        showErrorDialog(context: context, message: result.toString());
        break;
    }

  }
}
