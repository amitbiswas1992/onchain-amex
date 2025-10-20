import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../core/resources/app_secrets.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/network/result.dart';
import '../../data/models/borrower_profile.dart';
import '../../data/repositories/wallet_repo.dart';

final walletRepoProvider = Provider.autoDispose((ref) {
  return WalletRepo(dioService: ref.read(dioService));
});

final modelInitialized = StateProvider.autoDispose<bool>((ref) => false);

final availableCreditProvider =
    FutureProvider.autoDispose<Result<num?>>((ref) async {
  return await ref
      .read(walletRepoProvider)
      .getAvailableCredit(publicAddress: '');
});

final borrowerProfileProvider = FutureProvider.autoDispose
    .family<Result<BorrowerProfile?>, String>((ref, pId) async {
  return await ref
      .read(walletRepoProvider)
      .getBorrowerProfile(publicAddress: pId);
});

final appkitModalProvider =
    FutureProvider.autoDispose<ReownAppKitModal>((ref) async {
  ref.keepAlive();
  final appKitModal = ReownAppKitModal(
    context: AppNav.navKey.currentContext!,
    projectId: reownProjectId,
    logLevel: LogLevel.error,
    metadata: const PairingMetadata(
      name: 'TMRW',
      description: 'TMRW App',
      redirect: Redirect(
        native: 'tmrw://',
        linkMode: false,
      ),
    ),
  );

  await appKitModal.init();
  ref.read(modelInitialized.notifier).state = true;
  return appKitModal;
});
