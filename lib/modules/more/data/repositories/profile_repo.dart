import '../../../../core/utils/log_util.dart';
import '../../../../infrastructure/network/api_urls.dart';
import '../../../../infrastructure/network/dio_service.dart';
import '../../../../infrastructure/network/result.dart';
import '../../business/repository/profile_repo_interface.dart';
import '../models/profile.dart';

class ProfileRepo implements ProfileRepoInterface {
  final DioService dioService;

  ProfileRepo({required this.dioService});

  @override
  Future<Result<Profile?>> getProfile() async {
    try {
      final response = await dioService.get(ApiUrls.profile, useTokenizeHeader: true);
      return response.toResult(dataHandler: (json) => Profile.fromJson(json));
    } catch (error, stck) {
      return handleCatchAndReturnResult(error: error, stck: stck);
    }
  }
}