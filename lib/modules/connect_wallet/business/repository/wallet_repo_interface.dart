import '../../../../infrastructure/network/result.dart';

abstract interface class WalletRepoInterface {
  Future<Result> connectWallet({required Map<String, dynamic> payload});
}