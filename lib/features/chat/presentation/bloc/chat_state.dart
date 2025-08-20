import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_entity.dart';
import '../../../profile/data/models/profile_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class AllUsersLoaded extends ChatState {
  final List<ProfileModel> users;

  const AllUsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class AllChatUsersLoaded extends ChatState {
  final List<ChatEntity> chats;

  const AllChatUsersLoaded({required this.chats});

  @override
  List<Object> get props => [chats];
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object> get props => [message];
}

class ChatRefreshing extends ChatState {
  final List<ChatEntity> currentChats;

  const ChatRefreshing({required this.currentChats});

  @override
  List<Object> get props => [currentChats];
}