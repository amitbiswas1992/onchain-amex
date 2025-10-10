import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:reown_appkit/appkit_modal.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../core/constants/contract_constants.dart';
import '../../../../core/extensions/big_int_extensions.dart';
import 'wallet_service_interface.dart';

class WalletService implements WalletServiceInterface {
  final ReownAppKitModal appKitModal;
  bool _isInitialized = false;
  Future<void>? _loadingFuture;
  DeployedContract? _creditorContract;

  WalletService(this.appKitModal) {
    _loadingFuture = _loadContracts();
  }

  Future<void> _loadContracts() async {
    try {
      print('Starting to load contracts...');

      // Load USDC/Creditor Contract (Creditor.json)
      final creditorAbi = await rootBundle.loadString('assets/contracts/Creditor.json');
      final creditorAbiJson = json.decode(creditorAbi);

      _creditorContract = DeployedContract(
        ContractAbi.fromJson(
          json.encode(creditorAbiJson['abi'] ?? creditorAbiJson),
          'USDC',
        ),
        EthereumAddress.fromHex(ContractConstants.usdcAddress),
      );
      print('Creditor USDC contract loaded');

      _isInitialized = true;
      print('All contracts loaded successfully');
    } catch (e) {
      print('Error loading contracts: $e');
      _isInitialized = false;
    }
  }

  // Ensure contracts are loaded before use
  Future<void> _ensureInitialized() async {
    if (_loadingFuture != null) {
      await _loadingFuture;
    }
  }

  // Get connected wallet address
  String? get walletAddress {
    try {
      if (appKitModal.session == null) return null;
      // Get address from session namespaces
      final namespaces = appKitModal.session!.namespaces;
      if (namespaces == null) return null;

      for (final ns in namespaces.values) {
        for (final acc in ns.accounts) {
          // Account format: "eip155:11155111:0x..."
          final parts = acc.split(':');
          if (parts.length >= 3) {
            return parts[2]; // Return the address part
          }
        }
      }
      return null;
    } catch (e) {
      print('Error getting wallet address: $e');
      return null;
    }
  }

  EthereumAddress? get ethereumAddress {
    final address = walletAddress;
    if (address == null) return null;
    try {
      return EthereumAddress.fromHex(address);
    } catch (e) {
      print('Error parsing address: $e');
      return null;
    }
  }

  // Check if wallet is connected
  bool get isConnected {
    final connected = appKitModal.isConnected && ethereumAddress != null;
    print('BlockchainService.isConnected: $connected');
    print('  - appKitModal.isConnected: ${appKitModal.isConnected}');
    print('  - ethereumAddress: $ethereumAddress');
    print('  - sessionTopic: $sessionTopic');
    return connected;
  }

  bool get isInitialized => _isInitialized;

  // Get current chain ID
  String get currentChainId => 'eip155:${ContractConstants.chainId}';

  // Get session topic
  String? get sessionTopic => appKitModal.session?.topic;

  /// Repay USDC into vault
  /// @param amount USDC amount to deposit (in UI format)
  @override
  Future<String> repay(double amount) async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (!isConnected || _creditorContract == null || sessionTopic == null) {
      throw Exception('Wallet not connected');
    }

    // // Check allowance first
    // final allowance = await getUsdcAllowance();
    // if (allowance < amount) {
    //   throw Exception('Insufficient allowance. Please approve USDC first.');
    // }

    final contractAmount = amount.toBlockchainValue();

    try {
      final txHash = await appKitModal.requestWriteContract(
        topic: sessionTopic!,
        chainId: currentChainId,
        deployedContract: _creditorContract!,
        functionName: 'repay',
        parameters: [
          contractAmount,
          ethereumAddress, // receiver
        ],
        transaction: Transaction(from: ethereumAddress),
      );

      return txHash;
    } catch (e) {
      print('Error depositing: $e');
      throw Exception('Failed to deposit: ${e.toString()}');
    }
  }

}