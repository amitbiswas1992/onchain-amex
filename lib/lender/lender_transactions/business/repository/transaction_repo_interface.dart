import '../../../../infrastructure/network/result.dart';
import '../../data/models/transaction.dart';

abstract interface class TransactionRepoInterface {
  Future<Result<List<Transaction>?>> getTransactions({
    required int skipItem,
    required int perPage,
  });
}
