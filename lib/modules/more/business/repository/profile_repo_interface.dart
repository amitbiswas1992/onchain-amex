import '../../../../infrastructure/network/result.dart';
import '../../data/models/profile.dart';

abstract interface class ProfileRepoInterface {
  Future<Result<Profile?>> getProfile(); 
}