import '../../../../infrastructure/network/result.dart';
import '../../data/dto/register_dto.dart';
import '../../data/models/tokens_model.dart';

abstract interface class SignInRepoInterface {
  Future<Result<TokensModel?>> register({required RegisterDto dto});
}