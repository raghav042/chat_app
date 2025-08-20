import 'package:chat_app/features/chat/domain/entities/chat_entity.dart';

import '../../../profile/data/models/profile_model.dart';

abstract class ChatRepository {
  Future<List<ProfileModel>> getAllUsers(String userId);
  Future<List<ChatEntity>> getAllChatUsers(String userId);
}
