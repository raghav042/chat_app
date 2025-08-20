import 'package:equatable/equatable.dart';

import '../../../message/domain/entities/message_entity.dart';
import '../../../profile/domain/entities/profile_entity.dart';

class ChatEntity extends Equatable {
  const ChatEntity({
    required this.chatId,
    required this.userIds,
    this.otherUserProfile,
    this.lastMessage,
  });

  final String chatId;
  final List<String> userIds;
  final ProfileEntity? otherUserProfile;
  final MessageEntity? lastMessage;

  @override
  List<Object?> get props => [chatId, userIds, otherUserProfile, lastMessage];
}
