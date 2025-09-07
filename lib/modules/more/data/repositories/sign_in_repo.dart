import 'dart:convert';

import '../../../../core/utils/log_util.dart';
import '../../../../infrastructure/network/api_urls.dart';
import '../../../../infrastructure/network/dio_service.dart';
import '../../../../infrastructure/network/result.dart';
import '../../business/repository/sign_in_repo_interface.dart';
import '../dto/register_dto.dart';
import '../models/tokens_model.dart';

class SignInRepo implements SignInRepoInterface {
  final DioService dioService;

  SignInRepo({required this.dioService});

  @override
  Future<Result<TokensModel?>> register({required RegisterDto dto}) async {
    try {
      final response = await dioService.post(
        ApiUrls.register,
        body: dto.toJson(),
      );

      return response.toResult(dataHandler: (data) {
        return TokensModel.fromJson(data['tokens']);
      });
    } catch (error, stck) {
      return handleCatchAndReturnResult(error: error, stck: stck);
    }
  }
}
