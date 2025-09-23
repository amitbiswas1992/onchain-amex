import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../core/resources/app_secrets.dart';


class ConnectWalletScreen extends StatefulWidget {
  const ConnectWalletScreen({super.key});
  @override
  State<ConnectWalletScreen> createState() => _ConnectWalletScreenState();
}

class _ConnectWalletScreenState extends State<ConnectWalletScreen> {
  late final ReownAppKitModal _appKitModal;
  String? _address;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initAppKit();
  }

  Future<void> _initAppKit() async {

    // create the modal instance
    _appKitModal = ReownAppKitModal(
      context: context,
      projectId: reownProjectId,
      logLevel: LogLevel.error,
      metadata: const PairingMetadata(
        name: 'TMRW',
        description: 'TMRW App',
        // url: 'https://my-dapp.com',
        // icons: ['https://my-dapp.com/icon.png'],
        redirect: Redirect(
          native: 'tmrw://',                 // must match Info.plist / Android manifest
          // universal: 'https://my-dapp.com/app',    // optional
          linkMode: false,
        ),
      ),
    );

    _appKitModal.onModalConnect.subscribe((ModalConnect? event) {
      if (event == null) return;

      // Extract accounts from namespaces
      final namespaces = event.session.namespaces;
      if (namespaces != null) {
        for (final ns in namespaces.values) {
          for (final acc in ns.accounts) {
            // Format: "eip155:1:0x1234abcd..."
            final parts = acc.split(':');
            final address = parts.last;
            setState(() {
              _address = address;
            });
          }
        }
      }
    });

    // initialize client
    await _appKitModal.init();

    // update UI
    setState(() => _ready = true);
  }

  @override
  void dispose() {
    // if you enabled disconnectOnDispose=false you might want to disconnect here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reown AppKit Connect')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppKitModalConnectButton(appKit: _appKitModal),          // opens modal
            const SizedBox(height: 12),
            AppKitModalNetworkSelectButton(appKit: _appKitModal),    // choose network (opt)
            const SizedBox(height: 20),
            Text('Connected address: ${_address ?? "Not connected"}'),
            const SizedBox(height: 8),
            Visibility(
              visible: _appKitModal.isConnected,
              child: AppKitModalAccountButton(appKitModal: _appKitModal),
            ),
          ],
        ),
      ),
    );
  }
}
