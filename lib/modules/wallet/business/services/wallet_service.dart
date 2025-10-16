import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:reown_appkit/appkit_modal.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../core/constants/contract_constants.dart';
import '../../../../core/extensions/big_int_extensions.dart';
import 'dart:developer' as dev;

class WalletService {
  final ReownAppKitModal appKitModal;
  bool _isInitialized = false;
  Future<void>? _loadingFuture;
  DeployedContract? _creditorContract;
  DeployedContract? _usdcContract;

  WalletService(this.appKitModal) {
    _loadingFuture = _loadContracts();
  }

  Future<void> _loadContracts() async {
    try {
      print('Starting to load contracts...');

      // Load Creditor Contract (Creditor.json)
      final creditorAbi = await rootBundle.loadString('assets/contracts/Creditor.json');
      final creditorAbiJson = json.decode(creditorAbi);

      _creditorContract = DeployedContract(
        ContractAbi.fromJson(
          json.encode(creditorAbiJson['abi'] ?? creditorAbiJson),
          'Creditor',
        ),
        EthereumAddress.fromHex(ContractConstants.creditorAddress),
      );
      print('Creditor USDC contract loaded');

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

  /// Mint USDC tokens (for testing only)
  /// @param amount The amount of USDC to mint (in UI format, e.g., 1000)
  Future<String> mintUsdc(double amount) async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (!isConnected || _usdcContract == null || sessionTopic == null) {
      throw Exception('Wallet not connected');
    }

    final contractAmount = amount.multiplyByMillion();

    final txHash = await appKitModal.requestWriteContract(
      topic: sessionTopic!,
      chainId: currentChainId,
      deployedContract: _usdcContract!,
      functionName: 'mint',
      parameters: [ethereumAddress, contractAmount],
      transaction: Transaction(from: ethereumAddress),
    );
    // return '0xMockTransactionHashForMinting'; // Mock transaction hash for illustration
    return txHash;
  }

  Future<double> getUsdcAllowance() async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (!isConnected || _usdcContract == null || sessionTopic == null)
      return 0.0;

    try {
      final result = await appKitModal.requestReadContract(
        topic: sessionTopic!,
        chainId: currentChainId,
        deployedContract: _usdcContract!,
        functionName: 'allowance',
        parameters: [
          ethereumAddress,
          EthereumAddress.fromHex(ContractConstants.vaultAddress),
        ],
      );

      final allowance = result.first as BigInt;
      return allowance.dividedByMillion();
    } catch (e) {
      print('Error getting USDC allowance: $e');
      return 0.0;
    }
  }

  /// Approve Vault to spend USDC
  /// @param amount The amount of USDC to approve (in UI format)
  Future<String> approveUsdc(double amount) async {
    dev.log('approval amount => ${amount}');
    // Wait for contracts to load
    await _ensureInitialized();

    if (!isConnected || _usdcContract == null || sessionTopic == null) {
      throw Exception('Wallet not connected');
    }

    final contractAmount = amount.multiplyByMillion();

    try {
      final txHash = await appKitModal.requestWriteContract(
        topic: sessionTopic!,
        chainId: currentChainId,
        deployedContract: _usdcContract!,
        functionName: 'approve',
        parameters: [
          EthereumAddress.fromHex(ContractConstants.creditorAddress),
          contractAmount,
        ],
        transaction: Transaction(from: ethereumAddress),
      );

      return txHash;
    } catch (e) {
      print('Error approving USDC: $e');
      throw Exception('Failed to approve USDC: ${e.toString()}');
    }
  }

  /// Repay USDC into vault
  /// @param amount USDC amount to deposit (in UI format)
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

    final contractAmount = amount.multiplyByMillion();

    try {
      final txHash = await appKitModal.requestWriteContract(
        topic: sessionTopic!,
        chainId: currentChainId,
        deployedContract: _creditorContract!,
        functionName: 'repay',
        parameters: [
          contractAmount,
          EthereumAddress.fromHex(ContractConstants.usdcAddress), // receiver
        ],
        transaction: Transaction(from: ethereumAddress),
      );

      return txHash;
    } catch (e) {
      print('Error depositing: $e');
      throw Exception('Failed to deposit: ${e.toString()}');
    }
  }

  /// Repay USDC into vault
  /// @param amount USDC amount to deposit (in UI format)
  Future<String> spend({required double amount, required String merchantPublicAddress}) async {
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

    final contractAmount = amount.multiplyByMillion();

    try {
      final txHash = await appKitModal.requestWriteContract(
        topic: sessionTopic!,
        chainId: currentChainId,
        deployedContract: _creditorContract!,
        functionName: 'spend',
        parameters: [
          ethereumAddress, // borrower address
          EthereumAddress.fromHex(merchantPublicAddress),
          contractAmount,
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