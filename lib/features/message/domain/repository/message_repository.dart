import '../entities/message_entity.dart';

abstract class MessageRepository {
  Stream<List<MessageEntity>> getMessages(
      String currentUserId, String otherUserId);
  Future<void> sendMessage(MessageEntity message);
  Future<void> updateMessage(MessageEntity message);
  Future<void> deleteMessage(
      String messageId, String senderId, String receiverId);
  Future<MessageEntity?> getLastMessage(
      String currentUserId, String otherUserId);
}
