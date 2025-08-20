import '../entities/message_entity.dart';
import '../repository/message_repository.dart';

class SendMessageUseCase {
  final MessageRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call(MessageEntity message) async {
    await repository.sendMessage(message);
  }
}