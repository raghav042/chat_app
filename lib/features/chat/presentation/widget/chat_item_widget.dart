import 'package:chat_app/features/message/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/chat_entity.dart';
import '../screens/chat_list_screen.dart';

class ChatItemWidget extends StatelessWidget {
  final ChatEntity chat;
  final String currentUserId;

  const ChatItemWidget({
    super.key,
    required this.chat,
    required this.currentUserId,
  });

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (messageDate == today) {
        return DateFormat('HH:mm').format(dateTime);
      } else if (messageDate == today.subtract(const Duration(days: 1))) {
        return 'Yesterday';
      } else if (now.difference(dateTime).inDays < 7) {
        return DateFormat('EEE').format(dateTime);
      } else {
        return DateFormat('dd/MM/yy').format(dateTime);
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final otherUser = chat.otherUserProfile;
    final lastMessage = chat.lastMessage;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.blue[100],
        child: Text(
          otherUser?.name.isNotEmpty == true
              ? otherUser!.name[0].toUpperCase()
              : '?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
      ),
      title: Text(
        otherUser?.name ?? 'Unknown User',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: lastMessage != null
          ? Row(
        children: [
          if (lastMessage!.senderId == currentUserId) ...[
            const Icon(
              Icons.done_all,
              size: 16,
              color: Colors.blue,
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Text(
              lastMessage!.text,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      )
          : Text(
        'Tap to start chatting',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (lastMessage != null) ...[
            Text(
              _formatTimestamp(lastMessage!.timestamp),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
          ],
          // Online status indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: otherUser?.isOnline == true ? Colors.green : Colors.grey[400],
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        if (otherUser != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MessageScreen(

                otherUser: otherUser,

              ),
            ),
          );
        }
      },
    );
  }
}