import '../../../../infrastructure/network/result.dart';
import '../../data/models/borrower_profile.dart';
import '../../data/models/transaction_model.dart';

abstract interface class WalletRepoInterface {
  Future<Result<TransactionModel?>> connectWallet({required Map<String, dynamic> payload});
  Future<Result<num?>> getAvailableCredit({required String publicAddress});
  Future<Result<BorrowerProfile?>> getBorrowerProfile({required String publicAddress});
}