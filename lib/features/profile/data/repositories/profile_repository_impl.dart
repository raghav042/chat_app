import '../../../../core/app_exception.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/local/profile_local_datasource.dart';
import '../datasources/remote/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;

  ProfileRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<ProfileEntity?> getProfile(String uid) async {
    try {
      final profile = await _localDataSource.getProfile(uid);
      return profile?.toEntity();
    } on AppException {
      // If the profile isn't in the cache, try the remote source.
      try {
        final profile = await _remoteDataSource.getProfile(uid);
        if (profile != null) {
          await _localDataSource.cacheProfile(profile);
          return profile.toEntity();
        }
        return null; // Profile not found remotely.
      } catch (e) {
        throw AppException('Failed to get profile: $e');
      }
    }
  }

  /// Updates a user's profile both remotely (Firestore) and locally (Hive).
  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    try {
      final profileModel = ProfileModel.fromEntity(profile);
      await _remoteDataSource.updateProfile(profileModel);
      await _localDataSource.cacheProfile(profileModel);
    } catch (e) {
      throw AppException('Failed to update profile: $e');
    }
  }

  /// Creates a user's profile both remotely and locally.
  @override
  Future<void> createProfile(ProfileEntity profile) async {
    try {
      final profileModel = ProfileModel.fromEntity(profile);
      await _remoteDataSource.createProfile(profileModel);
      await _localDataSource.cacheProfile(profileModel);
    } catch (e) {
      throw AppException('Failed to create profile: $e');
    }
  }
}
