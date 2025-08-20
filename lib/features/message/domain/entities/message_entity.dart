import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final String timestamp;
  final bool isEdited;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isEdited = false,
  });

  String get chatId {
    final ids = [senderId, receiverId]..sort();
    return ids.join('_');
  }

  @override
  List<Object?> get props => [id, senderId, receiverId, text, timestamp, isEdited];
}