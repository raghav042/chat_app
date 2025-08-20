import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

abstract class UpdateProfileUseCase {
  Future<void> execute(ProfileEntity profile);
}

class UpdateProfileUseCaseImpl implements UpdateProfileUseCase {
  final ProfileRepository _repository;
  UpdateProfileUseCaseImpl(this._repository);

  @override
  Future<void> execute(ProfileEntity profile) {
    return _repository.updateProfile(profile);
  }
}