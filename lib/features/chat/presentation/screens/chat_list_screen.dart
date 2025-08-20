import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widget/chat_item_widget.dart';
import 'all_user_screen.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (_currentUserId.isNotEmpty) {
      context.read<ChatBloc>().add(GetAllChatUsersEvent(userId: _currentUserId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AllUsersScreen(currentUserId: _currentUserId),
                ),
              );
            },
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AllChatUsersLoaded) {
            if (state.chats.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No chats yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start a conversation with someone',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AllUsersScreen(currentUserId: _currentUserId),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('Find People'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ChatBloc>().add(RefreshChatsEvent(userId: _currentUserId));
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: state.chats.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final chat = state.chats[index];
                  return ChatItemWidget(
                    chat: chat,
                    currentUserId: _currentUserId,
                  );
                },
              ),
            );
          }

          if (state is ChatRefreshing) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ChatBloc>().add(RefreshChatsEvent(userId: _currentUserId));
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: state.currentChats.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final chat = state.currentChats[index];
                  return ChatItemWidget(
                    chat: chat,
                    currentUserId: _currentUserId,
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}