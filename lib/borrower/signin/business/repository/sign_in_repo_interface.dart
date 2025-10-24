import '../../../../infrastructure/network/result.dart';
import '../../data/dto/register_dto.dart';
import '../../data/models/register_model.dart';

abstract interface class SignInRepoInterface {
  Future<Result<RegisterModel?>> registerWithEmail({required RegisterDto dto});
  Future<Result<dynamic>> verifyEmailOtp({
    required Map<String, dynamic> payload,
    required bool isEmail,
  });
  Future<Result> resendOtpToEmail({
    required Map<String, dynamic> payload,
    required bool isEmail,
  });
  Future<Result<RegisterModel?>> login({
    required Map<String, dynamic> payload,
    required bool isEmail,
  });
  Future<Result> sendPasswordResetOtp({required Map<String, dynamic> payload});
  Future<Result> resetPassword({required Map<String, dynamic> payload});
  Future<Result> logout();
}
