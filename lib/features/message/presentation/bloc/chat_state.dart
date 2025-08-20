import 'package:equatable/equatable.dart';
import '../../domain/entities/message_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MessageEntity> messages;

  const ChatLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}

class MessageSending extends ChatState {
  final List<MessageEntity> messages;

  const MessageSending(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageSent extends ChatState {
  final List<MessageEntity> messages;

  const MessageSent(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageUpdated extends ChatState {
  final List<MessageEntity> messages;

  const MessageUpdated(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessageDeleted extends ChatState {
  final List<MessageEntity> messages;

  const MessageDeleted(this.messages);

  @override
  List<Object> get props => [messages];
}