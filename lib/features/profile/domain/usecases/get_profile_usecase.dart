import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

abstract class GetProfileUseCase {
  Future<ProfileEntity?> execute(String uid);
}

class GetProfileUseCaseImpl implements GetProfileUseCase {
  final ProfileRepository _repository;
  GetProfileUseCaseImpl(this._repository);

  @override
  Future<ProfileEntity?> execute(String uid) {
    return _repository.getProfile(uid);
  }
}