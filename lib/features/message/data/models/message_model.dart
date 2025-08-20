import 'package:hive_ce/hive.dart';
import '../../domain/entities/message_entity.dart';

part 'message_model.g.dart';

@HiveType(typeId: 1)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String senderId;

  @HiveField(2)
  final String receiverId;

  @HiveField(3)
  final String text;

  @HiveField(4)
  final String timestamp;

  @HiveField(5)
  final bool isEdited;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isEdited = false,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] ?? '',
      isEdited: map['isEdited'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
      'isEdited': isEdited,
    };
  }

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? text,
    String? timestamp,
    bool? isEdited,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      senderId: entity.senderId,
      receiverId: entity.receiverId,
      text: entity.text,
      timestamp: entity.timestamp,
      isEdited: entity.isEdited,
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      timestamp: timestamp,
      isEdited: isEdited,
    );
  }
}
