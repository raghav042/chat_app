import '../../../profile/data/datasources/local/profile_local_datasource.dart';
import '../../../profile/data/datasources/remote/profile_remote_datasource.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.authDataSource,
    required this.profileRemoteDataSource,
    required this.profileLocalDataSource,
  });
  final AuthDataSource authDataSource;
  final ProfileRemoteDataSource profileRemoteDataSource;
  final ProfileLocalDataSource profileLocalDataSource;

  @override
  Future<void> register(
      {required String email, required String password}) async {
    final user = await authDataSource.register(
      email: email,
      password: password,
    );

    final profile = ProfileModel(
      uid: user.uid,
      email: user.email,
      createdAt: DateTime.now().toIso8601String(),
    );

    await profileRemoteDataSource.createProfile(profile);
    await profileLocalDataSource.cacheProfile(profile);
  }

  @override
  Future<ProfileEntity?> login(
      {required String email, required String password}) async {
    final user = await authDataSource.login(email: email, password: password);
    final profile = await profileRemoteDataSource.getProfile(user.uid);
    if (profile == null) return null;

    await profileLocalDataSource.cacheProfile(profile);
    return profile.toEntity();
  }

  @override
  Future<void> logout() async {
    await authDataSource.logout();
    await profileLocalDataSource.clearCache();
  }
}
