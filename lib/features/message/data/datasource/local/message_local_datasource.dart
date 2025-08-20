import 'package:hive_ce/hive.dart';

import '../../models/message_model.dart';

abstract class MessageLocalDataSource {
  Future<List<MessageModel>> getCachedMessages(String chatId);
  Future<void> cacheMessages(String chatId, List<MessageModel> messages);
  Future<void> cacheMessage(MessageModel message);
  Future<void> updateCachedMessage(MessageModel message);
  Future<void> deleteCachedMessage({
    required String messageId,
    required String chatId,
  });
  Future<void> clearCache();
}

class MessageLocalDataSourceImpl implements MessageLocalDataSource {
  MessageLocalDataSourceImpl(this._messageBox);
  final Box<MessageModel> _messageBox;

  @override
  Future<List<MessageModel>> getCachedMessages(String chatId) async {
    final messages = <MessageModel>[];
    for (final entry in _messageBox.toMap().entries) {
      if (entry.key.toString().startsWith(chatId)) {
        messages.add(entry.value);
      }
    }
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  @override
  Future<void> cacheMessages(String chatId, List<MessageModel> messages) async {
    final keysToDelete = _messageBox.keys
        .where((key) => key.toString().startsWith(chatId))
        .toList();

    for (final key in keysToDelete) {
      await _messageBox.delete(key);
    }

    for (int i = 0; i < messages.length; i++) {
      await _messageBox.put('${chatId}_${messages[i].id}', messages[i]);
    }
  }

  @override
  Future<void> cacheMessage(MessageModel message) async {
    final chatId = message.id;
    await _messageBox.put('${chatId}_${message.id}', message);
  }

  @override
  Future<void> updateCachedMessage(MessageModel message) async {
    final chatId = message.id;
    await _messageBox.put('${chatId}_${message.id}', message);
  }

  @override
  Future<void> deleteCachedMessage(
      {required String messageId, required String chatId}) async {
    await _messageBox.delete('${chatId}_$messageId');
  }

  @override
  Future<void> clearCache() async {
    await _messageBox.clear();
  }
}
