import '../../../profile/domain/entities/profile_entity.dart';

abstract class AuthRepository {
  Future<ProfileEntity> register({required String email, required String password});
  Future<ProfileEntity?> login({required String email, required String password});
  Future<void> logout();
}
