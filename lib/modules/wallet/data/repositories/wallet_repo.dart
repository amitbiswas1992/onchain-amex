import '../../../../core/utils/log_util.dart';
import '../../../../infrastructure/network/api_urls.dart';
import '../../../../infrastructure/network/dio_service.dart';
import '../../../../infrastructure/network/result.dart';
import '../../business/repository/wallet_repo_interface.dart';
import '../models/borrower_profile.dart';
import '../models/transaction_model.dart';

class WalletRepo implements WalletRepoInterface {
  final DioService dioService;

  WalletRepo({required this.dioService});

  @override
  Future<Result<TransactionModel?>> connectWallet({required Map<String, dynamic> payload}) async {
    try {
      final response = await dioService.post(
        ApiUrls.connectWallet,
        body: payload,
        useTokenizeHeader: true,
      );

      return response.toResult(dataHandler: (data) => TransactionModel.fromJson(data));
    } catch (error, stck) {
      return handleCatchAndReturnResult(error: error, stck: stck);
    }
  }

  @override
  Future<Result<num?>> getAvailableCredit({required String publicAddress}) async {
    try {
      final response = await dioService.get(
        ApiUrls.availableCredit,
        useTokenizeHeader: true,
      );

      return response.toResult(dataHandler: (data) {
        return num.tryParse(data['availableCredit'] ?? '0');
      });
    } catch (error, stck) {
      return handleCatchAndReturnResult(error: error, stck: stck);
    }
  }

  @override
  Future<Result<BorrowerProfile?>> getBorrowerProfile({required String publicAddress}) async {
    try {
      final response = await dioService.get(
        ApiUrls.borrowerProfile(publicAddress),
        useTokenizeHeader: true,
      );
      return response.toResult(dataHandler: (data) => BorrowerProfile.fromJson(data));
    } catch (error, stck) {
      return handleCatchAndReturnResult(error: error, stck: stck);
    }
  }
}
