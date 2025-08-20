import '../../domain/entities/message_entity.dart';
import '../../domain/repository/message_repository.dart';
import '../datasource/local/message_local_datasource.dart';
import '../datasource/remote/message_remote_datasource.dart';
import '../models/message_model.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;
  final MessageLocalDataSource localDataSource;

  MessageRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<List<MessageEntity>> getMessages(
    String currentUserId,
    String otherUserId,
  ) {
    final chatId = _getChatId(currentUserId, otherUserId);

    return remoteDataSource
        .getMessages(currentUserId: currentUserId, otherUserId: otherUserId)
        .map((messages) {
      localDataSource.cacheMessages(chatId, messages);
      return messages.cast<MessageEntity>();
    }).handleError((error) {
      // Return cached messages on error
      return localDataSource
          .getCachedMessages(chatId)
          .then((cached) => cached.cast<MessageEntity>());
    });
  }

  @override
  Future<void> sendMessage(MessageEntity message) async {
    final messageModel = MessageModel.fromEntity(message);

    try {
      await remoteDataSource.sendMessage(messageModel);
      await localDataSource.cacheMessage(messageModel);
    } catch (e) {
      await localDataSource.cacheMessage(messageModel);
      rethrow;
    }
  }

  @override
  Future<void> updateMessage(MessageEntity message) async {
    final messageModel = MessageModel.fromEntity(message);

    try {
      await remoteDataSource.updateMessage(messageModel);
      await localDataSource.updateCachedMessage(messageModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteMessage(
    String messageId,
    String senderId,
    String receiverId,
  ) async {
    final chatId = _getChatId(senderId, receiverId);

    try {
      await remoteDataSource.deleteMessage(
        messageId: messageId,
        senderId: senderId,
        receiverId: receiverId,
      );
      await localDataSource.deleteCachedMessage(
        messageId: messageId,
        chatId: chatId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MessageEntity?> getLastMessage(
    String currentUserId,
    String otherUserId,
  ) async {
    try {
      final message = await remoteDataSource.getLastMessage(
        currentUserId: currentUserId,
        otherUserId: otherUserId,
      );
      return message?.toEntity();
    } catch (e) {
      final chatId = _getChatId(currentUserId, otherUserId);
      final cachedMessages = await localDataSource.getCachedMessages(chatId);
      if (cachedMessages.isNotEmpty) {
        return cachedMessages.last.toEntity();
      }
      return null;
    }
  }

  String _getChatId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return ids.join('_');
  }
}
