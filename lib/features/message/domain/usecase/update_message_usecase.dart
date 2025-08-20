import '../entities/message_entity.dart';
import '../repository/message_repository.dart';

class UpdateMessageUseCase {
  final MessageRepository repository;

  UpdateMessageUseCase(this.repository);

  Future<void> call(MessageEntity message) async {
    await repository.updateMessage(message);
  }
}