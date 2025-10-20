import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../borrower/wallet/presentation/providers/wallet_providers.dart';
import '../services/blockchain_service.dart';
import 'debouce_query_controller.dart';

part 'blockchain_controller.g.dart';

// Blockchain Service Provider
@riverpod
BlockchainService blockchainService(Ref ref) {
  final appKitModal = ref.watch(appkitModalProvider).value;
  if (appKitModal == null) {
    throw Exception('AppKit Modal not initialized');
  }
  return BlockchainService(appKitModal);
}

// USDC Balance Provider
@riverpod
FutureOr<double> usdcBalance(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  if (!blockchainService.isConnected) return 0.0;
  return blockchainService.getUsdcBalance();
}

// Vault Balance (Shares) Provider
@riverpod
FutureOr<double> vaultBalance(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  if (!blockchainService.isConnected) return 0.0;
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
  if (!blockchainService.isConnected) return 0.0;
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
  if (!blockchainService.isConnected) return 0.0;
  return await blockchainService.getUsdcAllowance();
}

// Max Withdrawable Amount Provider
@riverpod
FutureOr<double> maxWithdrawableAmount(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  if (!blockchainService.isConnected) return 0.0;
  return await blockchainService.getMaxWithdrawableAmount();
}

// User AToken Balance Provider
@riverpod
FutureOr<double> userATokenBalance(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  if (!blockchainService.isConnected) return 0.0;
  return await blockchainService.getUserATokenBalance();
}

// User Yield Provider (from contract)
@riverpod
FutureOr<double> userYield(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  if (!blockchainService.isConnected) return 0.0;
  return await blockchainService.getUserYield();
}

@riverpod
FutureOr<double?> previewDeposit(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  final amount = ref.watch(debouceQueryControllerProvider);
  if (amount <= 0) return null;
  if (!blockchainService.isConnected) return null;
  return await blockchainService.previewDeposit(amount);
}

@riverpod
FutureOr<double?> previewWithdraw(Ref ref) async {
  final blockchainService = ref.watch(blockchainServiceProvider);
  final amount = ref.watch(debouceQueryControllerProvider);
  if (amount <= 0) return null;
  if (!blockchainService.isConnected) return null;
  return await blockchainService.previewWithdraw(amount);
}
