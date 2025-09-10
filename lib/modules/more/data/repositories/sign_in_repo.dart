import 'dart:convert';

import '../../../../core/utils/log_util.dart';
import '../../../../infrastructure/network/api_urls.dart';
import '../../../../infrastructure/network/dio_service.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../signin/data/models/register_model.dart';
import '../../business/repository/sign_in_repo_interface.dart';
import '../dto/register_dto.dart';
import '../../../signin/data/models/tokens_model.dart';

class SignInRepo implements SignInRepoInterface {
  final DioService dioService;

  SignInRepo({required this.dioService});

  @override
  Future<Result<RegisterModel?>> registerWithEmail({required RegisterDto dto}) async {
    try {
      final response = await dioService.post(
        ApiUrls.register,
        body: dto.toJson(),
      );

      return response.toResult(dataHandler: (data) {
        return RegisterModel(
          tokensModel: TokensModel.fromJson(data['tokens']),
          userMap: data['user'],
        );
      });
    } catch (error, stck) {
      return handleCatchAndReturnResult(error: error, stck: stck);
    }
  }

  @override
  Future<Result> verifyEmailOtp({required Map<String, dynamic> payload}) async {
    try {
      final response = await dioService.post(
        ApiUrls.verifyOtpForEmail,
        body: payload,
      );

      return response.toResult(dataHandler: (json) {
        return null;
      });
    } catch (error, stck) {
      return handleCatchAndReturnResult(error: error, stck: stck);
    }
  }
}
