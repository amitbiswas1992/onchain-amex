import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

import '../../../core/constants/contract_constants.dart';
import '../../../core/services/web3_service.dart';
import '../../../core/utils/decimal_converter.dart';

/// Blockchain service using web3dart for smart contract interactions
class Web3BlockchainService {
  final Web3Service web3Service;
  DeployedContract? _usdcContract;
  DeployedContract? _vaultContract;
  DeployedContract? _creditorContract;
  bool _isInitialized = false;
  Future<void>? _loadingFuture;

  Web3BlockchainService(this.web3Service) {
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
          jsonEncode(usdcAbiJson['abi']),
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
          jsonEncode(vaultAbiJson['abi']),
          'TMRWVault',
        ),
        EthereumAddress.fromHex(ContractConstants.vaultAddress),
      );
      print('Vault contract loaded');

      // Load Creditor Contract (Creditor.json)
      final creditorAbi = await rootBundle.loadString(
        'assets/contracts/Creditor.json',
      );
      final creditorAbiJson = json.decode(creditorAbi);

      _creditorContract = DeployedContract(
        ContractAbi.fromJson(
          jsonEncode(creditorAbiJson['abi']),
          'Creditor',
        ),
        EthereumAddress.fromHex(ContractConstants.creditorAddress),
      );
      print('Creditor contract loaded');

      _isInitialized = true;
      print('All contracts loaded successfully');
    } catch (e) {
      print('Error loading contracts: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  // Ensure contracts are loaded before use
  Future<void> _ensureInitialized() async {
    if (_loadingFuture != null) {
      await _loadingFuture;
    }
    if (!_isInitialized) {
      throw Exception('Contracts not initialized');
    }
  }

  // Get connected wallet address
  Future<EthereumAddress?> get walletAddress async {
    return await web3Service.getWalletAddress();
  }

  // Check if wallet is connected
  Future<bool> get isConnected async {
    final address = await walletAddress;
    return address != null;
  }

  bool get isInitialized => _isInitialized;

  // ============================================================
  // USDC CONTRACT METHODS
  // ============================================================

  /// Get USDC balance for the connected wallet
  Future<double> getUsdcBalance() async {
    print('getUsdcBalance called');

    await _ensureInitialized();

    final address = await walletAddress;
    if (address == null || _usdcContract == null) {
      print('Returning 0.0 (not connected or missing contract)');
      return 0.0;
    }

    try {
      print('Calling balanceOf...');
      final result = await web3Service.callContractMethod(
        contract: _usdcContract!,
        functionName: 'balanceOf',
        params: [address],
      );

      print('Result: $result');
      if (result.isEmpty) return 0.0;
      final balance = result.first as BigInt;
      final uiBalance = DecimalConverter.toUiAmount(balance);
      print('Balance: $uiBalance USDC');
      return uiBalance;
    } catch (e) {
      print('Error getting USDC balance: $e');
      return 0.0;
    }
  }

  /// Mint USDC tokens (for testing only)
  /// @param amount The amount of USDC to mint (in UI format, e.g., 1000)
  Future<String> mintUsdc(double amount) async {
    await _ensureInitialized();

    final address = await walletAddress;
    final credentials = await web3Service.getCredentials();

    if (address == null || credentials == null || _usdcContract == null) {
      throw Exception('Wallet not connected');
    }

    final contractAmount = DecimalConverter.toContractAmount(amount);

    final txHash = await web3Service.sendContractTransaction(
      credentials: credentials,
      contract: _usdcContract!,
      functionName: 'mint',
      params: [address, contractAmount],
    );

    return txHash;
  }

  /// Approve Vault to spend USDC
  /// @param amount The amount of USDC to approve (in UI format)
  Future<String> approveUsdc(double amount) async {
    await _ensureInitialized();

    final credentials = await web3Service.getCredentials();
    if (credentials == null || _usdcContract == null) {
      throw Exception('Wallet not connected');
    }

    final contractAmount = DecimalConverter.toContractAmount(amount);

    final txHash = await web3Service.sendContractTransaction(
      credentials: credentials,
      contract: _usdcContract!,
      functionName: 'approve',
      params: [
        EthereumAddress.fromHex(ContractConstants.vaultAddress),
        contractAmount,
      ],
    );

    return txHash;
  }

  /// Check USDC allowance for Vault
  Future<double> getUsdcAllowance() async {
    await _ensureInitialized();

    final address = await walletAddress;
    if (address == null || _usdcContract == null) {
      return 0.0;
    }

    try {
      final result = await web3Service.callContractMethod(
        contract: _usdcContract!,
        functionName: 'allowance',
        params: [
          address,
          EthereumAddress.fromHex(ContractConstants.vaultAddress),
        ],
      );

      if (result.isEmpty) return 0.0;
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
    await _ensureInitialized();

    final address = await walletAddress;
    if (address == null || _vaultContract == null) {
      return 0.0;
    }

    try {
      final result = await web3Service.callContractMethod(
        contract: _vaultContract!,
        functionName: 'balanceOf',
        params: [address],
      );

      if (result.isEmpty) return 0.0;
      final balance = result.first as BigInt;
      return DecimalConverter.toUiAmount(balance);
    } catch (e) {
      print('Error getting vault balance: $e');
      return 0.0;
    }
  }

  /// Preview deposit - shows how many shares user will receive
  /// @param amount USDC amount to deposit (in UI format)
  Future<double> previewDeposit(double amount) async {
    await _ensureInitialized();

    if (_vaultContract == null) return 0.0;

    try {
      final contractAmount = DecimalConverter.toContractAmount(amount);

      final result = await web3Service.callContractMethod(
        contract: _vaultContract!,
        functionName: 'previewDeposit',
        params: [contractAmount],
      );

      if (result.isEmpty) return 0.0;
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
    await _ensureInitialized();

    final address = await walletAddress;
    final credentials = await web3Service.getCredentials();

    if (address == null || credentials == null || _vaultContract == null) {
      throw Exception('Wallet not connected');
    }

    final contractAmount = DecimalConverter.toContractAmount(amount);

    final txHash = await web3Service.sendContractTransaction(
      credentials: credentials,
      contract: _vaultContract!,
      functionName: 'deposit',
      params: [
        contractAmount,
        address, // receiver
      ],
    );

    return txHash;
  }

  /// Preview withdraw - shows how much USDC user will receive for shares
  /// @param amount Number of shares to withdraw (in UI format)
  Future<double> previewWithdraw(double amount) async {
    await _ensureInitialized();

    if (_vaultContract == null) return 0.0;

    try {
      final contractAmount = DecimalConverter.toContractAmount(amount);

      final result = await web3Service.callContractMethod(
        contract: _vaultContract!,
        functionName: 'previewWithdraw',
        params: [contractAmount],
      );

      if (result.isEmpty) return 0.0;
      final assets = result.first as BigInt;
      return DecimalConverter.toUiAmount(assets);
    } catch (e) {
      print('Error previewing withdraw: $e');
      return 0.0;
    }
  }

  /// Get max withdrawable amount (in USDC)
  Future<double> getMaxWithdrawableAmount() async {
    await _ensureInitialized();

    final address = await walletAddress;
    if (address == null || _vaultContract == null) return 0.0;

    try {
      final result = await web3Service.callContractMethod(
        contract: _vaultContract!,
        functionName: 'maxWithdraw',
        params: [address],
      );

      if (result.isEmpty) return 0.0;
      final maxWithdrawable = result.first as BigInt;
      return DecimalConverter.toUiAmount(maxWithdrawable);
    } catch (e) {
      print('Error getting max withdrawable: $e');
      return 0.0;
    }
  }

  /// Get user's aToken balance (total value in vault)
  Future<double> getUserATokenBalance() async {
    await _ensureInitialized();

    final address = await walletAddress;
    if (address == null || _vaultContract == null) return 0.0;
    print('User address: $address');
    try {
      final result = await web3Service.callContractMethod(
        contract: _vaultContract!,
        functionName: 'userATokenBalance',
        params: [address],
      );
      print('getUserATokenBalance result: $result');

      if (result.isEmpty) {
        print('Warning: getUserATokenBalance returned empty result');
        return 0.0;
      }

      final balance = result.first as BigInt;
      return DecimalConverter.toUiAmount(balance);
    } catch (e) {
      print('Error getting aToken balance: $e');
      return 0.0;
    }
  }

  /// Get user's yield earned
  Future<double> getUserYield() async {
    await _ensureInitialized();

    final address = await walletAddress;
    if (address == null || _vaultContract == null) return 0.0;

    try {
      final result = await web3Service.callContractMethod(
        contract: _vaultContract!,
        functionName: 'getUserYield',
        params: [address],
      );

      if (result.isEmpty) return 0.0;
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
    await _ensureInitialized();

    final address = await walletAddress;
    final credentials = await web3Service.getCredentials();

    if (address == null || credentials == null || _vaultContract == null) {
      throw Exception('Wallet not connected');
    }

    final contractAmount = DecimalConverter.toContractAmount(amount);

    final txHash = await web3Service.sendContractTransaction(
      credentials: credentials,
      contract: _vaultContract!,
      functionName: 'withdraw',
      params: [
        contractAmount,
        address, // receiver
        address, // owner
      ],
    );

    return txHash;
  }

  /// Withdraw (redeem shares for USDC) - Legacy method
  /// @param shares Number of shares to withdraw (in UI format)
  Future<String> withdraw(double shares) async {
    await _ensureInitialized();

    final address = await walletAddress;
    final credentials = await web3Service.getCredentials();

    if (address == null || credentials == null || _vaultContract == null) {
      throw Exception('Wallet not connected');
    }

    final contractShares = DecimalConverter.toContractAmount(shares);

    try {
      final txHash = await web3Service.sendContractTransaction(
        credentials: credentials,
        contract: _vaultContract!,
        functionName: 'redeem',
        params: [
          contractShares,
          address, // receiver
          address, // owner
        ],
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

  /// Merchant Withdraw USDC from Creditor contract
  /// @param amount USDC amount to withdraw (in UI format)
  /// Returns transaction hash
  Future<String> merchantWithdraw(double amount) async {
    await _ensureInitialized();

    final address = await walletAddress;
    final credentials = await web3Service.getCredentials();

    if (address == null || credentials == null || _creditorContract == null) {
      throw Exception('Wallet not connected');
    }

    final contractAmount = DecimalConverter.toContractAmount(amount);

    print('Merchant withdrawing amount: $contractAmount USDC');

    final txHash = await web3Service.sendContractTransaction(
      credentials: credentials,
      contract: _creditorContract!,
      functionName: 'merchantWithdraw',
      params: [
        contractAmount,
        EthereumAddress.fromHex(ContractConstants.usdcAddress),
      ],
    );
    print('txHash: $txHash');

    return txHash;
  }

  /// Repay USDC into vault
  /// @param amount USDC amount to deposit (in UI format)
  Future<String> repay(double amount) async {
    await _ensureInitialized();

    final address = await walletAddress;
    final credentials = await web3Service.getCredentials();

    if (address == null || credentials == null || _creditorContract == null) {
      throw Exception('Wallet not connected');
    }

    final contractAmount = DecimalConverter.toContractAmount(amount);

    final txHash = await web3Service.sendContractTransaction(
      credentials: credentials,
      contract: _creditorContract!,
      functionName: 'repay',
      params: [
        contractAmount,
        EthereumAddress.fromHex(ContractConstants.usdcAddress), // receiver
      ],
    );

    return txHash;
  }

  /// Spend USDC
  /// @param amount USDC amount to spend (in UI format)
  /// @param merchantPublicAddress Merchant's wallet address
  Future<String> spend({
    required double amount,
    required String merchantPublicAddress,
  }) async {
    await _ensureInitialized();

    final address = await walletAddress;
    final credentials = await web3Service.getCredentials();

    if (address == null || credentials == null || _creditorContract == null) {
      throw Exception('Wallet not connected');
    }

    final contractAmount = DecimalConverter.toContractAmount(amount);

    print(
      'Spending amount in contract format: $contractAmount for merchant: $merchantPublicAddress my address: $address',
    );

    final txHash = await web3Service.sendContractTransaction(
      credentials: credentials,
      contract: _creditorContract!,
      functionName: 'spend',
      params: [
        address, // borrower address
        EthereumAddress.fromHex(merchantPublicAddress),
        contractAmount,
      ],
    );

    return txHash;
  }

  void dispose() {
    // Cleanup if needed
  }
}
