
import '../../../../core/utils/log_util.dart';
import '../../../../infrastructure/network/api_urls.dart';
import '../../../../infrastructure/network/dio_service.dart';
import '../../../../infrastructure/network/result.dart';
import '../../business/repository/kyc_repo_interface.dart';

class KycRepo implements KycRepoInterface {
  final DioService dioService;

  KycRepo({required this.dioService});

  @override
  Future<Result> updateKycStatus({required Map<String, dynamic> payload}) async {
    try {
      return (await dioService.post(
        ApiUrls.updateKycStatus,
        body: payload,
        useTokenizeHeader: true,
      )).toResult(dataHandler: null);
    } catch (error, stck) {
      return handleCatchAndReturnResult(error: error, stck: stck);
    }
  }
}
