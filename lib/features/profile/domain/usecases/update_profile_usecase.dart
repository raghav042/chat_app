import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;
  UpdateProfileUseCase(this._repository);

  Future<void> execute(ProfileEntity profile) {
    return _repository.updateProfile(profile);
  }
}
