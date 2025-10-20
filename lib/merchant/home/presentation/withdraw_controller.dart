import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../borrower/wallet/presentation/providers/wallet_providers.dart';
import '../data/withdraw_repo.dart';

part 'withdraw_controller.g.dart';

// Withdraw Repository Provider
@riverpod
WithdrawRepo withdrawRepo(Ref ref) {
  final appKitModal = ref.watch(appkitModalProvider).value;
  if (appKitModal == null) {
    throw Exception('AppKit Modal not initialized');
  }
  return WithdrawRepo(appKitModal);
}

// USDC Balance Provider
@riverpod
FutureOr<double> usdcBalance(Ref ref) async {
  final withdrawRepo = ref.watch(withdrawRepoProvider);
  if (!withdrawRepo.isConnected) return 0.0;
  return withdrawRepo.getUsdcBalance();
}
