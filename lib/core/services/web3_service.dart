import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

/// Web3 Service for managing Ethereum wallet interactions
/// Uses Sepolia testnet RPC
class Web3Service {
  static const String sepoliaRpcUrl =
      'https://ethereum-sepolia-rpc.publicnode.com';
  static const int sepoliaChainId = 11155111;

  late Web3Client _client;
  final SharedPreferences _sharedPreferences;

  static const String _privateKeyStorageKey = 'web3_private_key';
  static const String _walletAddressStorageKey = 'web3_wallet_address';

  Web3Service(this._sharedPreferences) {
    _client = Web3Client(sepoliaRpcUrl, http.Client());
  }

  /// Get Web3Client instance
  Web3Client get client => _client;

  /// Generate a new Ethereum wallet
  Future<EthPrivateKey> generateNewWallet() async {
    final random = Random.secure();
    final credentials = EthPrivateKey.createRandom(random);

    // Convert private key bytes to hex string
    final privateKeyHex = hex.encode(credentials.privateKey);

    // Store the private key securely
    await _sharedPreferences.setString(
      _privateKeyStorageKey,
      privateKeyHex,
    );

    // Store the wallet address
    final address = await credentials.extractAddress();
    await _sharedPreferences.setString(
      _walletAddressStorageKey,
      address.hex,
    );

    return credentials;
  }

  /// Get stored private key
  Future<String?> getStoredPrivateKey() async {
    return _sharedPreferences.getString(_privateKeyStorageKey);
  }

  /// Get stored wallet address
  Future<String?> getStoredWalletAddress() async {
    return _sharedPreferences.getString(_walletAddressStorageKey);
  }

  /// Import wallet from private key
  Future<EthPrivateKey> importWalletFromPrivateKey(String privateKeyHex) async {
    // Remove whitespace
    privateKeyHex =
        privateKeyHex.trim().replaceAll(' ', '').replaceAll('\n', '');

    // Remove '0x' prefix if present
    if (privateKeyHex.startsWith('0x') || privateKeyHex.startsWith('0X')) {
      privateKeyHex = privateKeyHex.substring(2);
    }

    // Validate hex string length (should be 64 characters for 32 bytes)
    if (privateKeyHex.length != 64) {
      throw ArgumentError(
        'Invalid private key length. Expected 64 hex characters, got ${privateKeyHex.length}',
      );
    }

    // Validate hex characters
    if (!RegExp(r'^[0-9a-fA-F]+$').hasMatch(privateKeyHex)) {
      throw ArgumentError(
        'Private key contains invalid characters. Only hexadecimal characters are allowed.',
      );
    }

    try {
      final credentials = EthPrivateKey.fromHex(privateKeyHex);

      // Store the private key securely
      await _sharedPreferences.setString(
        _privateKeyStorageKey,
        privateKeyHex,
      );

      // Store the wallet address
      final address = credentials.address;
      await _sharedPreferences.setString(
        _walletAddressStorageKey,
        address.hex,
      );

      return credentials;
    } catch (e) {
      throw ArgumentError('Failed to import wallet: ${e.toString()}');
    }
  }

  /// Get credentials from stored private key
  Future<EthPrivateKey?> getCredentials() async {
    final privateKeyHex = await getStoredPrivateKey();
    print('Retrieved private key: $privateKeyHex');
    if (privateKeyHex == null) return null;

    return EthPrivateKey.fromHex(privateKeyHex);
  }

  /// Get wallet address from credentials
  Future<EthereumAddress?> getWalletAddress() async {
    final credentials = await getCredentials();
    if (credentials == null) return null;

    return credentials.address;
  }

  /// Get ETH balance
  Future<EtherAmount> getBalance(EthereumAddress address) async {
    return await _client.getBalance(address);
  }

  /// Get ETH balance as formatted string
  Future<String> getBalanceFormatted(EthereumAddress address) async {
    final balance = await getBalance(address);
    return balance.getValueInUnit(EtherUnit.ether).toStringAsFixed(4);
  }

  /// Check if wallet exists
  Future<bool> hasWallet() async {
    final privateKey = await getStoredPrivateKey();
    return privateKey != null;
  }

  /// Clear stored wallet data
  Future<void> clearWallet() async {
    await _sharedPreferences.remove(_privateKeyStorageKey);
    await _sharedPreferences.remove(_walletAddressStorageKey);
  }

  /// Get current gas price
  Future<EtherAmount> getGasPrice() async {
    return await _client.getGasPrice();
  }

  /// Estimate gas for a transaction
  Future<BigInt> estimateGas({
    required EthereumAddress sender,
    required EthereumAddress receiver,
    EtherAmount? value,
    Uint8List? data,
  }) async {
    return await _client.estimateGas(
      sender: sender,
      to: receiver,
      value: value,
      data: data,
    );
  }

  /// Send ETH transaction
  Future<String> sendTransaction({
    required EthPrivateKey credentials,
    required EthereumAddress to,
    required EtherAmount amount,
  }) async {
    final transaction = Transaction(
      to: to,
      value: amount,
    );

    final txHash = await _client.sendTransaction(
      credentials,
      transaction,
      chainId: sepoliaChainId,
    );

    return txHash;
  }

  /// Call a contract method (read-only)
  Future<List<dynamic>> callContractMethod({
    required DeployedContract contract,
    required String functionName,
    required List<dynamic> params,
    EthereumAddress? sender,
  }) async {
    final function = contract.function(functionName);
    return await _client.call(
      contract: contract,
      function: function,
      params: params,
      sender: sender,
    );
  }

  /// Send a contract transaction (write operation)
  Future<String> sendContractTransaction({
    required EthPrivateKey credentials,
    required DeployedContract contract,
    required String functionName,
    required List<dynamic> params,
    EtherAmount? value,
    int? gasLimit,
  }) async {
    final function = contract.function(functionName);
    final transaction = Transaction.callContract(
      contract: contract,
      function: function,
      parameters: params,
      value: value,
    );

    final txHash = await _client.sendTransaction(
      credentials,
      transaction,
      chainId: sepoliaChainId,
    );
    print('txHash: $txHash');
    // print('transaction $transaction} ');
    return txHash;
  }

  /// Get transaction receipt
  Future<TransactionReceipt?> getTransactionReceipt(String txHash) async {
    return await _client.getTransactionReceipt(txHash);
  }

  /// Wait for transaction confirmation
  Future<TransactionReceipt?> waitForTransactionReceipt(
    String txHash, {
    Duration timeout = const Duration(seconds: 120),
    Duration checkInterval = const Duration(seconds: 2),
  }) async {
    final startTime = DateTime.now();

    while (DateTime.now().difference(startTime) < timeout) {
      final receipt = await getTransactionReceipt(txHash);
      if (receipt != null) {
        return receipt;
      }
      await Future.delayed(checkInterval);
    }

    return null;
  }

  /// Dispose resources
  void dispose() {
    _client.dispose();
  }
}
