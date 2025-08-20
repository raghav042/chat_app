import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/message_model.dart';

abstract class MessageRemoteDataSource {
  Future<void> sendMessage(MessageModel message);
  Future<void> updateMessage(MessageModel message);
  Future<void> deleteMessage({
    required String messageId,
    required String senderId,
    required String receiverId,
  });
  Future<MessageModel?> getLastMessage({
    required String currentUserId,
    required String otherUserId,
  });
  Stream<List<MessageModel>> getMessages({
    required String currentUserId,
    required String otherUserId,
  });
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  MessageRemoteDataSourceImpl({required this.firestore});
  final FirebaseFirestore firestore;
  CollectionReference get _chatsCollection => firestore.collection('chats');

  @override
  Future<void> sendMessage(MessageModel message) async {
    try {
      final chatId = message.id;
      await _chatsCollection
          .doc(chatId)
          .collection('messages')
          .doc(message.id)
          .set(message.toMap());
    } catch (e) {
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }

  @override
  Future<void> updateMessage(MessageModel message) async {
    try {
      final chatId = message.id;
      await _chatsCollection
          .doc(chatId)
          .collection('messages')
          .doc(message.id)
          .update(message.toMap());
    } catch (e) {
      throw Exception('Failed to update message: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteMessage({
    required String messageId,
    required String senderId,
    required String receiverId,
  }) async {
    try {
      final chatId = _getChatId(senderId, receiverId);
      await _chatsCollection
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete message: ${e.toString()}');
    }
  }

  @override
  Future<MessageModel?> getLastMessage({
    required String currentUserId,
    required String otherUserId,
  }) async {
    try {
      final chatId = _getChatId(currentUserId, otherUserId);
      final snapshot = await _chatsCollection
          .doc(chatId)
          .collection('messages')
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return MessageModel.fromMap(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<List<MessageModel>> getMessages({
    required String currentUserId,
    required String otherUserId,
  }) {
    final chatId = _getChatId(currentUserId, otherUserId);

    return _chatsCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('id', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.data());
      }).toList();
    });
  }

  String _getChatId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return ids.join('_');
  }
}
