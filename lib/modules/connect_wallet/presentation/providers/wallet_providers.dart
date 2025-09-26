import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../infrastructure/di/global_providers.dart';
import '../../data/repositories/wallet_repo.dart';

final walletRepoProvider = Provider.autoDispose((ref) {
  return WalletRepo(dioService: ref.read(dioService));
});