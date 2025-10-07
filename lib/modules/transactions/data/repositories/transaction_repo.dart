import '../../../../core/utils/log_util.dart';
import '../../../../infrastructure/network/api_urls.dart';
import '../../../../infrastructure/network/dio_service.dart';
import '../../../../infrastructure/network/result.dart';
import '../../business/repository/transaction_repo_interface.dart';
import '../models/transaction.dart';

class TransactionRepo implements TransactionRepoInterface {
  final DioService dioService;

  TransactionRepo({required this.dioService});

  @override
  Future<Result<List<Transaction>?>> getTransactions({
    required String publicAddress,
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await dioService.get(
        ApiUrls.transactionsHistory(publicAddress),
        useTokenizeHeader: true,
        query: {
          'limit': perPage.toString(),
          'offset': page.toString(),
        },
      );
      return response.toResult(
        dataHandler: (jsonList) {
          return jsonList.map((json) => Transaction.fromJson(json)).toList();
        },
      );
    } catch (error, stck) {
      return handleCatchAndReturnResult(error: error, stck: stck);
    }
  }
}
