import '../../../profile/domain/entities/profile_entity.dart';
import '../repository/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._authRepository);
  final AuthRepository _authRepository;

  Future<ProfileEntity?> execute(
      {required String email, required String password}) async {
    return await _authRepository.login(email: email, password: password);
  }
}
