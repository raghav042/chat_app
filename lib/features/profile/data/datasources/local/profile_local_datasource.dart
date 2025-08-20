import 'package:hive_ce/hive.dart';

import '../../../../../core/app_exception.dart';
import '../../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> cacheProfile(ProfileModel profile);
  Future<ProfileModel?> getProfile(String uid);
  Future<void> clearCache();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileLocalDataSourceImpl(this._profileBox);
  final Box<ProfileModel> _profileBox;

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    try {
      await _profileBox.put(profile.uid, profile);
    } catch (e) {
      throw AppException('Failed to cache profile: $e');
    }
  }

  @override
  Future<ProfileModel?> getProfile(String uid) async {
    return _profileBox.get(uid);
  }

  @override
  Future<void> clearCache() async {
    await _profileBox.clear();
  }
}
