import 'package:hive_ce/hive.dart';

import '../../../message/data/models/message_model.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../domain/entities/chat_entity.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 2)
class ChatModel extends HiveObject {
  @HiveField(0)
  final String chatId;

  @HiveField(1)
  final List<String> userIds;

  @HiveField(2)
  final ProfileModel? otherUserProfile;

  @HiveField(3)
  final MessageModel? lastMessage;

  ChatModel({
    required this.chatId,
    required this.userIds,
    this.otherUserProfile,
    this.lastMessage,
  });

  ChatEntity toEntity() {
    return ChatEntity(
      chatId: chatId,
      userIds: userIds,
      otherUserProfile: otherUserProfile?.toEntity(),
      lastMessage: lastMessage?.toEntity(),
    );
  }
}
