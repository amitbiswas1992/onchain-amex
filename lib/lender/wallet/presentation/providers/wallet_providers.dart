import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../borrower/wallet/data/models/borrower_profile.dart';
import '../../../../borrower/wallet/data/repositories/wallet_repo.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/network/result.dart';

final walletRepoProvider = Provider.autoDispose((ref) {
  return WalletRepo(dioService: ref.read(dioService));
});

final availableCreditProvider =
    FutureProvider.autoDispose.family<Result<num?>, String>((ref, pId) async {
  return await ref
      .read(walletRepoProvider)
      .getAvailableCredit(publicAddress: pId);
});

final borrowerProfileProvider = FutureProvider.autoDispose
    .family<Result<BorrowerProfile?>, String>((ref, pId) async {
  return ref.read(walletRepoProvider).getBorrowerProfile(publicAddress: pId);
});
