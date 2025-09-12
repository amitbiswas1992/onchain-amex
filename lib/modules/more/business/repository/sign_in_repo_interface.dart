import '../../../../infrastructure/network/result.dart';
import '../../../signin/data/models/register_model.dart';
import '../../data/dto/register_dto.dart';
import '../../../signin/data/models/tokens_model.dart';

abstract interface class SignInRepoInterface {
  Future<Result<RegisterModel?>> registerWithEmail({required RegisterDto dto});
  Future<Result<dynamic>> verifyEmailOtp({required Map<String, dynamic> payload});
  Future<Result> resendOtpToEmail({required Map<String, dynamic> payload});
  Future<Result<RegisterModel?>> login ({ required Map<String, dynamic> payload});
}