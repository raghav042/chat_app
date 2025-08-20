import 'package:chat_app/features/message/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import '../../../profile/data/models/profile_model.dart';

class UserItemWidget extends StatelessWidget {
  final ProfileModel user;
  final String currentUserId;

  const UserItemWidget({
    super.key,
    required this.user,
    required this.currentUserId,
  });

  String _generateChatId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return ids.join('_');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue[100],
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
          // Online status indicator
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: user.isOnline ? Colors.green : Colors.grey[400],
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.email,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (user.bio.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              user.bio,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (user.isOnline)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Online',
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Icon(
            Icons.chat_bubble_outline,
            color: Colors.grey[400],
          ),
        ],
      ),
      onTap: () {
        final chatId = _generateChatId(currentUserId, user.uid);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MessageScreen(

              otherUser: user.toEntity(),

            ),
          ),
        );
      },
    );
  }
}