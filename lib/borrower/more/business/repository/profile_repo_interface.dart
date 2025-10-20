import '../../../../infrastructure/network/result.dart';
import '../../../../merchant/home/model/merchant_profile.dart';
import '../../data/models/profile.dart';

abstract interface class ProfileRepoInterface {
  Future<Result<Profile?>> getProfile();
  Future<Result<MerchantProfile?>> getMerchantProfile();

  Future<Result> updateProfile({required Map<String, dynamic> payload});
}
