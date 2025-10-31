import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../core/constants/contract_constants.dart';
import '../../../core/utils/decimal_converter.dart';

class WithdrawRepo {
  // Singleton instance
  static WithdrawRepo? _instance;

  final ReownAppKitModal appKitModal;
  DeployedContract? _usdcContract;
  DeployedContract? _creditorContract;
  bool _isInitialized = false;
  Future<void>? _loadingFuture;

  // Private constructor
  WithdrawRepo._internal(this.appKitModal) {
    _loadingFuture = _loadContracts();
  }

  // Factory constructor to return singleton instance
  factory WithdrawRepo(ReownAppKitModal appKitModal) {
    _instance ??= WithdrawRepo._internal(appKitModal);
    return _instance!;
  }

  // Optional: Method to get the instance (if already initialized)
  static WithdrawRepo? get instance => _instance;

  Future<void> _loadContracts() async {
    try {
      print('Starting to load contracts...');

      // Load USDC Contract (usdc.json)
      final usdcAbi = await rootBundle.loadString('assets/contracts/usdc.json');
      final usdcAbiJson = json.decode(usdcAbi);

      _usdcContract = DeployedContract(
        ContractAbi.fromJson(
          json.encode(usdcAbiJson['abi'] ?? usdcAbiJson),
          'USDC',
        ),
        EthereumAddress.fromHex(ContractConstants.usdcAddress),
      );
      print('USDC contract loaded');

      // Load Vault Contract (Creditor.json)
      final creditorAbi = await rootBundle.loadString(
        'assets/contracts/Creditor.json',
      );
      final creditorAbiJson = json.decode(creditorAbi);

      _creditorContract = DeployedContract(
        ContractAbi.fromJson(
          json.encode(creditorAbiJson['abi'] ?? creditorAbiJson),
          'Creditor',
        ),
        EthereumAddress.fromHex(ContractConstants.creditorAddress),
      );
      print('Vault contract loaded');

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

  // ============================================================
  // USDC CONTRACT METHODS
  // ============================================================

  /// Get USDC balance for the connected wallet
  Future<double> getUsdcBalance() async {
    print('getUsdcBalance called');

    // Wait for contracts to load
    await _ensureInitialized();

    print('BlockchainService.isConnected: $isConnected');
    print('  - appKitModal.isConnected: ${appKitModal.isConnected}');
    print('  - ethereumAddress: $ethereumAddress');
    print('  - sessionTopic: $sessionTopic');
    print('  - isConnected: $isConnected');
    print('  - _usdcContract: ${_usdcContract != null}');
    print('  - sessionTopic: $sessionTopic');

    if (!isConnected || _usdcContract == null || sessionTopic == null) {
      print('  - Returning 0.0 (not connected or missing contract/topic)');
      return 0.0;
    }

    try {
      print('  - Calling requestReadContract...');
      final result = await appKitModal.requestReadContract(
        topic: sessionTopic!,
        chainId: currentChainId,
        deployedContract: _usdcContract!,
        functionName: 'balanceOf',
        parameters: [ethereumAddress],
      );

      print('  - Result: $result');
      final balance = result.first as BigInt;
      final uiBalance = DecimalConverter.toUiAmount(balance);
      print('  - Balance: $uiBalance USDC');
      return uiBalance;
    } catch (e) {
      print('Error getting USDC balance: $e');
      return 0.0;
    }
  }

  /// Withdraw USDC from vault by specifying amount
  /// @param amount USDC amount to withdraw (in UI format)
  /// Returns transaction hash
  Future<String> withdrawAmount(double amount) async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (!isConnected || _creditorContract == null || sessionTopic == null) {
      throw Exception('Wallet not connected');
    }

    final contractAmount = DecimalConverter.toContractAmount(amount);

    final txHash = await appKitModal.requestWriteContract(
      topic: sessionTopic!,
      chainId: currentChainId,
      deployedContract: _creditorContract!,
      functionName: 'merchantWithdraw',
      parameters: [
        contractAmount,
        // ethereumAddress,
        EthereumAddress.fromHex(ContractConstants.usdcAddress),
      ],
      transaction: Transaction(from: ethereumAddress),
    );
    if (txHash == null) {
      throw Exception('Transaction failed');
    }
    if (txHash is Map && txHash['code'] == 5000) {
      throw Exception('User rejected the transaction');
    }

    return txHash;
  }
}
