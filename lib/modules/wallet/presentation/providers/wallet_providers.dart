import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reown_appkit/appkit_modal.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../core/resources/app_secrets.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/texts/transaction_hash_text.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../more/presentation/providers/more_providers.dart';
import '../../data/models/borrower_profile.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/wallet_repo.dart';

final walletRepoProvider = Provider.autoDispose((ref) {
  return WalletRepo(dioService: ref.read(dioService));
});

final modelInitialized = StateProvider.autoDispose<bool>((ref) => false);


final availableCreditProvider =
    FutureProvider.autoDispose.family<Result<num?>, String>((ref, pId) async {
  return await ref.read(walletRepoProvider).getAvailableCredit(publicAddress: pId);
});

final borrowerProfileProvider =
    FutureProvider.autoDispose.family<Result<BorrowerProfile?>, String>((ref, pId) async {
  return await ref.read(walletRepoProvider).getBorrowerProfile(publicAddress: pId);
});

final appkitModalProvider = FutureProvider((ref) async {
  final appKitModal = ReownAppKitModal(
    context: AppNav.navKey.currentContext!,
    projectId: reownProjectId,
    logLevel: LogLevel.error,
    metadata: PairingMetadata(
      name: 'TMRW',
      description: 'TMRW App',
      redirect: Redirect(
        native: Platform.isIOS ? 'tmrw:///more-screen' : 'tmrw://',
        linkMode: false,
      ),
    ),
  );

  await appKitModal.init();
  ref.read(modelInitialized.notifier).state = true;
  return appKitModal;
});