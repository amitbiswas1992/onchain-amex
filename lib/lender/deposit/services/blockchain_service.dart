import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../core/constants/contract_constants.dart';
import '../../../core/utils/decimal_converter.dart';

class BlockchainService {
  final ReownAppKitModal appKitModal;
  DeployedContract? _usdcContract;
  DeployedContract? _vaultContract;
  bool _isInitialized = false;
  Future<void>? _loadingFuture;

  BlockchainService(this.appKitModal) {
    _loadingFuture = _loadContracts();
  }

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

      // Load Vault Contract (TMRWVault.json)
      final vaultAbi = await rootBundle.loadString(
        'assets/contracts/TMRWVault.json',
      );
      final vaultAbiJson = json.decode(vaultAbi);

      _vaultContract = DeployedContract(
        ContractAbi.fromJson(
          json.encode(vaultAbiJson['abi'] ?? vaultAbiJson),
          'TMRWVault',
        ),
        EthereumAddress.fromHex(ContractConstants.vaultAddress),
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

  /// Mint USDC tokens (for testing only)
  /// @param amount The amount of USDC to mint (in UI format, e.g., 1000)
  Future<String> mintUsdc(double amount) async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (!isConnected || _usdcContract == null || sessionTopic == null) {
      throw Exception('Wallet not connected');
    }

    final contractAmount = DecimalConverter.toContractAmount(amount);

    final txHash = await appKitModal.requestWriteContract(
      topic: sessionTopic!,
      chainId: currentChainId,
      deployedContract: _usdcContract!,
      functionName: 'mint',
      parameters: [ethereumAddress, contractAmount],
      transaction: Transaction(from: ethereumAddress),
    );
    if (txHash is Map && txHash['code'] == 5000) {
      throw Exception('User rejected the transaction');
    }

    return txHash;
  }

  /// Approve Vault to spend USDC
  /// @param amount The amount of USDC to approve (in UI format)
  Future<String> approveUsdc(double amount) async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (!isConnected || _usdcContract == null || sessionTopic == null) {
      throw Exception('Wallet not connected');
    }

    final contractAmount = DecimalConverter.toContractAmount(amount);

    final txHash = await appKitModal.requestWriteContract(
      topic: sessionTopic!,
      chainId: currentChainId,
      deployedContract: _usdcContract!,
      functionName: 'approve',
      parameters: [
        EthereumAddress.fromHex(ContractConstants.vaultAddress),
        contractAmount,
      ],
      transaction: Transaction(from: ethereumAddress),
    );
    if (txHash is Map && txHash['code'] == 5000) {
      throw Exception('User rejected the transaction');
    }

    return txHash;
  }

  /// Check USDC allowance for Vault
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
      return DecimalConverter.toUiAmount(allowance);
    } catch (e) {
      print('Error getting USDC allowance: $e');
      return 0.0;
    }
  }

  // ============================================================
  // VAULT CONTRACT METHODS
  // ============================================================

  /// Get vault share balance for the connected wallet
  Future<double> getVaultBalance() async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (!isConnected || _vaultContract == null || sessionTopic == null) {
      return 0.0;
    }

    try {
      final result = await appKitModal.requestReadContract(
        topic: sessionTopic!,
        chainId: currentChainId,
        deployedContract: _vaultContract!,
        functionName: 'balanceOf',
        parameters: [ethereumAddress],
      );

      final balance = result.first as BigInt;
      return DecimalConverter.toUiAmount(balance);
    } catch (e) {
      print('Error getting vault balance: $e');
      return 0.0;
    }
  }

  // /// Get total assets (USDC value) for user's shares
  // Future<double> getTotalAssets() async {
  //   // Wait for contracts to load
  //   await _ensureInitialized();

  //   if (!isConnected || _vaultContract == null || sessionTopic == null)
  //     return 0.0;

  //   try {
  //     final shares = await getVaultBalance();
  //     if (shares == 0) return 0.0;

  //     final sharesInContract = DecimalConverter.toContractAmount(shares);

  //     final result = await appKitModal.requestReadContract(
  //       topic: sessionTopic!,
  //       chainId: currentChainId,
  //       deployedContract: _vaultContract!,
  //       functionName: 'convertToAssets',
  //       parameters: [sharesInContract],
  //     );

  //     final assets = result.first as BigInt;
  //     return DecimalConverter.toUiAmount(assets);
  //   } catch (e) {
  //     print('Error getting total assets: $e');
  //     return 0.0;
  //   }
  // }

  /// Preview deposit - shows how many shares user will receive
  /// @param amount USDC amount to deposit (in UI format)
  Future<double> previewDeposit(double amount) async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (_vaultContract == null || sessionTopic == null) return 0.0;

    try {
      final contractAmount = DecimalConverter.toContractAmount(amount);

      final result = await appKitModal.requestReadContract(
        topic: sessionTopic!,
        chainId: currentChainId,
        deployedContract: _vaultContract!,
        functionName: 'previewDeposit',
        parameters: [contractAmount],
      );

      final shares = result.first as BigInt;
      return DecimalConverter.toUiAmount(shares);
    } catch (e) {
      print('Error previewing deposit: $e');
      return 0.0;
    }
  }

  /// Deposit USDC into vault
  /// @param amount USDC amount to deposit (in UI format)
  Future<String> deposit(double amount) async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (!isConnected || _vaultContract == null || sessionTopic == null) {
      throw Exception('Wallet not connected');
    }

    // // Check allowance first
    // final allowance = await getUsdcAllowance();
    // if (allowance < amount) {
    //   throw Exception('Insufficient allowance. Please approve USDC first.');
    // }

    final contractAmount = DecimalConverter.toContractAmount(amount);

    final txHash = await appKitModal.requestWriteContract(
      topic: sessionTopic!,
      chainId: currentChainId,
      deployedContract: _vaultContract!,
      functionName: 'deposit',
      parameters: [
        contractAmount,
        ethereumAddress, // receiver
      ],
      transaction: Transaction(from: ethereumAddress),
    );
    if (txHash is Map && txHash['code'] == 5000) {
      throw Exception('User rejected the transaction');
    }

    return txHash;
  }

  /// Preview withdraw - shows how much USDC user will receive for shares
  /// @param shares Number of shares to withdraw (in UI format)
  Future<double> previewWithdraw(double amount) async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (_vaultContract == null || sessionTopic == null) return 0.0;

    try {
      final contractAmount = DecimalConverter.toContractAmount(amount);

      final result = await appKitModal.requestReadContract(
        topic: sessionTopic!,
        chainId: currentChainId,
        deployedContract: _vaultContract!,
        functionName: 'previewWithdraw',
        parameters: [contractAmount],
      );

      final assets = result.first as BigInt;
      return DecimalConverter.toUiAmount(assets);
    } catch (e) {
      print('Error previewing withdraw: $e');
      return 0.0;
    }
  }

  /// Get max withdrawable amount (in USDC)
  Future<double> getMaxWithdrawableAmount() async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (_vaultContract == null || sessionTopic == null) return 0.0;

    try {
      final result = await appKitModal.requestReadContract(
        topic: sessionTopic!,
        chainId: currentChainId,
        deployedContract: _vaultContract!,
        functionName: 'getMaxWithdrawableAmount',
        parameters: [ethereumAddress],
      );

      final maxWithdrawable = result.first as BigInt;
      return DecimalConverter.toUiAmount(maxWithdrawable);
    } catch (e) {
      print('Error getting max withdrawable: $e');
      return 0.0;
    }
  }

  /// Get user's aToken balance (total value in vault)
  Future<double> getUserATokenBalance() async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (_vaultContract == null || sessionTopic == null) return 0.0;

    try {
      final result = await appKitModal.requestReadContract(
        topic: sessionTopic!,
        chainId: currentChainId,
        deployedContract: _vaultContract!,
        functionName: 'userATokenBalance',
        parameters: [ethereumAddress],
      );

      final balance = result.first as BigInt;
      return DecimalConverter.toUiAmount(balance);
    } catch (e) {
      print('Error getting aToken balance: $e');
      return 0.0;
    }
  }

  /// Get user's yield earned
  Future<double> getUserYield() async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (_vaultContract == null || sessionTopic == null) return 0.0;

    try {
      final result = await appKitModal.requestReadContract(
        topic: sessionTopic!,
        chainId: currentChainId,
        deployedContract: _vaultContract!,
        functionName: 'getUserYield',
        parameters: [ethereumAddress],
      );

      final yieldAmount = result.first as BigInt;
      return DecimalConverter.toUiAmount(yieldAmount);
    } catch (e) {
      print('Error getting user yield: $e');
      return 0.0;
    }
  }

  /// Withdraw USDC from vault by specifying amount
  /// @param amount USDC amount to withdraw (in UI format)
  /// Returns transaction hash
  Future<String> withdrawAmount(double amount) async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (!isConnected || _vaultContract == null || sessionTopic == null) {
      throw Exception('Wallet not connected');
    }

    final contractAmount = DecimalConverter.toContractAmount(amount);

    final txHash = await appKitModal.requestWriteContract(
      topic: sessionTopic!,
      chainId: currentChainId,
      deployedContract: _vaultContract!,
      functionName: 'withdraw',
      parameters: [
        contractAmount,
        ethereumAddress, // receiver
        ethereumAddress, // owner
      ],
      transaction: Transaction(from: ethereumAddress),
    );
    if (txHash is Map && txHash['code'] == 5000) {
      throw Exception('User rejected the transaction');
    }

    return txHash;
  }

  /// Withdraw (redeem shares for USDC) - Legacy method
  /// @param shares Number of shares to withdraw (in UI format)
  Future<String> withdraw(double shares) async {
    // Wait for contracts to load
    await _ensureInitialized();

    if (!isConnected || _vaultContract == null || sessionTopic == null) {
      throw Exception('Wallet not connected');
    }

    final contractShares = DecimalConverter.toContractAmount(shares);

    try {
      final txHash = await appKitModal.requestWriteContract(
        topic: sessionTopic!,
        chainId: currentChainId,
        deployedContract: _vaultContract!,
        functionName: 'redeem',
        parameters: [
          contractShares,
          ethereumAddress, // receiver
          ethereumAddress, // owner
        ],
        transaction: Transaction(from: ethereumAddress),
      );

      return txHash;
    } catch (e) {
      print('Error withdrawing: $e');
      throw Exception('Failed to withdraw: ${e.toString()}');
    }
  }

  /// Get current APY (Annual Percentage Yield)
  Future<double> getCurrentApy() async {
    // This would need to be calculated based on vault's total assets growth
    // For now, returning a placeholder
    // You'll need to implement this based on your contract's logic
    return 5.4; // 5.4% APY
  }

  void dispose() {
    // Cleanup if needed
  }
}
