import '../../../profile/data/models/profile_model.dart';
import '../repositories/chat_repository.dart';

class GetAllUsersUseCase {
  final ChatRepository _repository;

  GetAllUsersUseCase(this._repository);

  Future<List<ProfileModel>> execute(String userId) {
    return _repository.getAllUsers(userId);
  }
}
