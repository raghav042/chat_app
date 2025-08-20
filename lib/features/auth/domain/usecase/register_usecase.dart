import 'package:chat_app/features/profile/domain/entities/profile_entity.dart';

import '../repository/auth_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this._authRepository);
  final AuthRepository _authRepository;

  Future<ProfileEntity> execute(
      {required String email, required String password}) async {
  return  await _authRepository.register(email: email, password: password);
  }
}
