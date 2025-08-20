import '../entities/message_entity.dart';
import '../repository/message_repository.dart';

class GetMessagesUseCase {
  final MessageRepository repository;

  GetMessagesUseCase(this.repository);

  Stream<List<MessageEntity>> call(String currentUserId, String otherUserId) {
    return repository.getMessages(currentUserId, otherUserId);
  }
}