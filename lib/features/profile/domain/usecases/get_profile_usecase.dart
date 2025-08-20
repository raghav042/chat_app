import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;
  GetProfileUseCase(this._repository);

  Future<ProfileEntity?> execute(String uid) {
    return _repository.getProfile(uid);
  }
}
