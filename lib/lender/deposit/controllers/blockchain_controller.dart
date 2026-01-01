import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/web3_service.dart';
import '../../../infrastructure/di/global_providers.dart';
import '../services/web3_blockchain_service.dart';
import 'debouce_query_controller.dart';

part 'blockchain_controller.g.dart';

// Web3 Service Provider
final web3ServiceProvider = Provider<Web3Service>((ref) {
  return Web3Service(ref.read(sharedPreferencesProvider));
});

// Blockchain Service Provider (using web3dart)
@riverpod
Web3BlockchainService blockchainService(Ref ref) {
  final web3Service = ref.watch(web3ServiceProvider);
  return Web3BlockchainService(web3Service);
}

// USDC Balance Provider
@riverpod
FutureOr<double> usdcBalance(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  final isConnected = await blockchainService.isConnected;
  if (!isConnected) return 0.0;
  return blockchainService.getUsdcBalance();
}

// Vault Balance (Shares) Provider
@riverpod
FutureOr<double> vaultBalance(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  final isConnected = await blockchainService.isConnected;
  if (!isConnected) return 0.0;
  return blockchainService.getVaultBalance();
}

// Total Assets Provider (USDC value of shares)
// @riverpod
// FutureOr<double> totalAssets(Ref ref) async {
//   final blockchainService = ref.watch(blockchainServiceProvider);
//   if (!blockchainService.isConnected) return 0.0;
//   ref.onDispose(() {
//     print('--------- Total Assets provider disposed -------------');
//   });
//   return blockchainService.getTotalAssets();
// }

// Yield Earned Provider
@riverpod
FutureOr<double> yieldEarned(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  final isConnected = await blockchainService.isConnected;
  if (!isConnected) return 0.0;
  return await blockchainService.getUserYield();
}

// Current APY Provider
@riverpod
FutureOr<double> currentApy(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  return await blockchainService.getCurrentApy();
}

// USDC Allowance Provider
@riverpod
FutureOr<double> usdcAllowance(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  final isConnected = await blockchainService.isConnected;
  if (!isConnected) return 0.0;
  return await blockchainService.getUsdcAllowance();
}

// Max Withdrawable Amount Provider
@riverpod
FutureOr<double> maxWithdrawableAmount(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  final isConnected = await blockchainService.isConnected;
  if (!isConnected) return 0.0;
  return await blockchainService.getMaxWithdrawableAmount();
}

// User AToken Balance Provider
@riverpod
FutureOr<double> userATokenBalance(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  final isConnected = await blockchainService.isConnected;
  if (!isConnected) return 0.0;
  return await blockchainService.getUserATokenBalance();
}

// User Yield Provider (from contract)
@riverpod
FutureOr<double> userYield(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  final isConnected = await blockchainService.isConnected;
  if (!isConnected) return 0.0;
  return await blockchainService.getUserYield();
}

@riverpod
FutureOr<double?> previewDeposit(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  final amount = ref.watch(debouceQueryControllerProvider);
  if (amount <= 0) return null;
  final isConnected = await blockchainService.isConnected;
  if (!isConnected) return null;
  return await blockchainService.previewDeposit(amount);
}

@riverpod
FutureOr<double?> previewWithdraw(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  final amount = ref.watch(debouceQueryControllerProvider);
  if (amount <= 0) return null;
  final isConnected = await blockchainService.isConnected;
  if (!isConnected) return null;
  return await blockchainService.previewWithdraw(amount);
}
