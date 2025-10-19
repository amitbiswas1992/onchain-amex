import '../../../../infrastructure/network/result.dart';

abstract interface class KycRepoInterface {
  Future<Result> updateKycStatus({required Map<String, dynamic> payload});
}