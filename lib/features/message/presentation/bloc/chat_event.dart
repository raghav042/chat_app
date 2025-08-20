import 'package:equatable/equatable.dart';
import '../../domain/entities/message_entity.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends ChatEvent {
  final String currentUserId;
  final String otherUserId;

  const LoadMessages({
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  List<Object> get props => [currentUserId, otherUserId];
}

class SendMessage extends ChatEvent {
  final String currentUserId;
  final String receiverId;
  final String text;

  const SendMessage({
    required this.currentUserId,
    required this.receiverId,
    required this.text,
  });

  @override
  List<Object> get props => [currentUserId, receiverId, text];
}

class UpdateMessage extends ChatEvent {
  final MessageEntity message;
  final String newText;

  const UpdateMessage({
    required this.message,
    required this.newText,
  });

  @override
  List<Object> get props => [message, newText];
}

class DeleteMessage extends ChatEvent {
  final MessageEntity message;

  const DeleteMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ClearMessages extends ChatEvent {}

class RefreshMessages extends ChatEvent {
  final String currentUserId;
  final String otherUserId;

  const RefreshMessages({
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  List<Object> get props => [currentUserId, otherUserId];
}