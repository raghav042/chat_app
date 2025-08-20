import 'package:chat_app/features/chat/data/models/chat_model.dart';
import 'package:hive_ce/hive.dart';

abstract class ChatLocalDataSource {
  Future<List<ChatModel>> getCachedChatUsers();
  Future<void> cacheChatUsers(List<ChatModel> chats);

  Future<void> clearCache();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  ChatLocalDataSourceImpl(this._chatBox);
  final Box<ChatModel> _chatBox;

  @override
  Future<void> cacheChatUsers(List<ChatModel> chats) async {
    _chatBox.clear();
    for (final chat in chats) {
      _chatBox.put(chat.chatId, chat);
    }
  }

  @override
  Future<List<ChatModel>> getCachedChatUsers() async {
    return _chatBox.values.toList();
  }

  @override
  Future<void> clearCache() async {
    await _chatBox.clear();
  }
}
