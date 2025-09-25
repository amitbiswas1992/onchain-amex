import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../core/resources/app_secrets.dart';
import '../../../../core/widgets/dialogs.dart';

class ConnectWalletController {
  final BuildContext context;
  final WidgetRef ref;

  ReownAppKitModal? _appKitModal;

  ConnectWalletController({
    required this.context,
    required this.ref,
  });

  /// Initializes and connects to MetaMask
  Future<String?> connectToMetaMask() async {
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
              hideDialog();
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

    showLoadingDialog(context: context, message: 'Getting things ready...');
    await _appKitModal?.init();

    // open modal UI to connect wallet
    await _appKitModal?.openModalView();
    hideDialog();
    // if (completer.isCompleted == false) {
    //   completer.complete(null);
    // }

    return completer.future;
  }

  void dispose() {
    _appKitModal?.dispose();
  }
}
