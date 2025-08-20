import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetAllChatUsersUseCase {
  final ChatRepository _repository;

  GetAllChatUsersUseCase(this._repository);

  Future<List<ChatEntity>> execute(String userId) {
    return _repository.getAllChatUsers(userId);
  }
}
