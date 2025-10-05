import '../../../../infrastructure/network/result.dart';
import '../../data/models/profile.dart';

abstract interface class ProfileRepoInterface {
  Future<Result<Profile?>> getProfile();
  Future<Result> updateProfile({required Map<String, dynamic> payload});
}