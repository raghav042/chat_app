import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetAllUsersEvent extends ChatEvent {
  final String userId;

  const GetAllUsersEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class GetAllChatUsersEvent extends ChatEvent {
  final String userId;

  const GetAllChatUsersEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class RefreshChatsEvent extends ChatEvent {
  final String userId;

  const RefreshChatsEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}