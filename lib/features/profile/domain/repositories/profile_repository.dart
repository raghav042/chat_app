import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity?> getProfile(String uid);
  Future<void> updateProfile(ProfileEntity profile);
  // This is used by AuthRepository to create the initial profile.
  Future<void> createProfile(ProfileEntity profile);
}