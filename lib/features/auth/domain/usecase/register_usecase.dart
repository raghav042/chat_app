import '../repository/auth_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this._authRepository);
  final AuthRepository _authRepository;

  Future<void> execute(
      {required String email, required String password}) async {
    await _authRepository.register(email: email, password: password);
  }
}
