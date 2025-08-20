import 'package:chat_app/features/chat/data/models/chat_model.dart';
import 'package:chat_app/features/message/data/datasource/remote/message_remote_datasource.dart';
import 'package:chat_app/features/message/data/models/message_model.dart';
import 'package:chat_app/features/profile/data/datasources/remote/profile_remote_datasource.dart';

import '../../../profile/data/models/profile_model.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/local/chat_local_datasource.dart';
import '../datasources/remote/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required this.chatRemoteDataSource,
    required this.chatLocalDataSource,
    required this.profileRemoteDataSource,
    required this.messageRemoteDataSource,
  });
  final ChatRemoteDataSource chatRemoteDataSource;
  final ChatLocalDataSource chatLocalDataSource;
  final ProfileRemoteDataSource profileRemoteDataSource;
  final MessageRemoteDataSource messageRemoteDataSource;

  @override
  Future<List<ChatEntity>> getAllChatUsers(String userId) async {
    final chatData = await chatRemoteDataSource.getAllChatData(userId);

    List<ChatModel> chats = [];
    for (Map<String, dynamic> chat in chatData) {
      // Get all the users in the chat
      final participants = List.from(chat['userIds']);
      // Remove the current user from the list
      participants.remove(userId);

      // Get the other user's profile
      final otherUserId = participants.first;
      final ProfileModel? otherUserProfile =
          await profileRemoteDataSource.getProfile(otherUserId);
      final MessageModel? lastMessage = await messageRemoteDataSource
          .getLastMessage(currentUserId: userId, otherUserId: otherUserId);

      final ChatModel chatModel = ChatModel(
        chatId: chat['chatId'],
        userIds: List.from(chat['userIds']),
        otherUserProfile: otherUserProfile,
        lastMessage: lastMessage,
      );

      chats.add(chatModel);
    }

    chatLocalDataSource.cacheChatUsers(chats);

    return chats.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<ProfileModel>> getAllUsers(String userId) async {
    final users = await chatRemoteDataSource.getAllUsers(userId);
    return users;
  }
}
