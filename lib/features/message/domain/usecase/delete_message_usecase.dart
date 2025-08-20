import '../repository/message_repository.dart';

class DeleteMessageUseCase {
  final MessageRepository repository;

  DeleteMessageUseCase(this.repository);

  Future<void> call(String messageId, String senderId, String receiverId) async {
    await repository.deleteMessage(messageId, senderId, receiverId);
  }
}