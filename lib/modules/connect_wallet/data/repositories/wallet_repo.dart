import '../../../../core/utils/log_util.dart';
import '../../../../infrastructure/network/api_urls.dart';
import '../../../../infrastructure/network/dio_service.dart';
import '../../../../infrastructure/network/result.dart';
import '../../business/repository/wallet_repo_interface.dart';

class WalletRepo implements WalletRepoInterface {
  final DioService dioService;

  WalletRepo({required this.dioService});

  @override
  Future<Result> connectWallet({required Map<String, dynamic> payload}) async {
    try {
      final response = await dioService.post(
        ApiUrls.connectWallet,
        body: payload,
        useTokenizeHeader: true,
      );

      return response.toResult(dataHandler: (json) => null);
    } catch (error, stck) {
      return handleCatchAndReturnResult(error: error, stck: stck);
    }
  }

}