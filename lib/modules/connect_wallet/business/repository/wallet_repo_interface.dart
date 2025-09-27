import '../../../../infrastructure/network/result.dart';
import '../../data/models/transaction_model.dart';

abstract interface class WalletRepoInterface {
  Future<Result<TransactionModel?>> connectWallet({required Map<String, dynamic> payload});
}