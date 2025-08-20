import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/connectivity/connectivity_bloc.dart';
import '../../../../core/connectivity/connectivity_state.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/message_action_dialog.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatScreen extends StatefulWidget {
  final ProfileEntity otherUser;

  const ChatScreen({super.key, required this.otherUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  late MessageBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = sl<MessageBloc>();
    _loadMessages();
  }

  void _loadMessages() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _chatBloc.add(LoadMessages(
        currentUserId: authState.user.uid,
        otherUserId: widget.otherUser.uid,
      ));
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    _chatBloc.add(SendMessage(
      currentUserId: authState.user.uid,
      receiverId: widget.otherUser.uid,
      text: text,
    ));

    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _showMessageActions(message) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    final canEdit = message.senderId == authState.user.uid;

    showModalBottomSheet(
      context: context,
      builder: (context) => MessageActionsDialog(
        message: message,
        canEdit: canEdit,
        onEdit: _editMessage,
        onDelete: _deleteMessage,
      ),
    );
  }

  void _editMessage(message) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: message.text);
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter new message...',
            ),
            maxLines: 3,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newText = controller.text.trim();
                if (newText.isNotEmpty && newText != message.text) {
                  _chatBloc.add(UpdateMessage(
                    message: message,
                    newText: newText,
                  ));
                }
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMessage(message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _chatBloc.add(DeleteMessage(message));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefreshMessages() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _chatBloc.add(RefreshMessages(
        currentUserId: authState.user.uid,
        otherUserId: widget.otherUser.uid,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    widget.otherUser.name.isNotEmpty
                        ? widget.otherUser.name[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.otherUser.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherUser.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.otherUser.isOnline ? 'Online' : 'Offline',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.tropicalBlue,
        actions: [
          BlocBuilder<ConnectivityBloc, ConnectivityState>(
            builder: (context, connectivityState) {
              if (connectivityState is ConnectivityOffline) {
                return const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.wifi_off, color: Colors.white),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _chatBloc,
        child: BlocConsumer<MessageBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is ChatLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });
            }
          },
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ChatError && state is! ChatLoaded) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load messages',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _onRefreshMessages,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final messages = state is ChatLoaded ? state.messages : [];
            final isConnected =
                context.watch<ConnectivityBloc>().state is ConnectivityOnline;

            return Column(
              children: [
                // Messages list
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No messages yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Start the conversation!',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _onRefreshMessages,
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(8),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final authState = context.read<AuthBloc>().state;
                              final currentUserId = authState is Authenticated
                                  ? authState.user.uid
                                  : '';
                              final isMe = message.senderId == currentUserId;

                              return GestureDetector(
                                onLongPress: () => _showMessageActions(message),
                                child: MessageBubble(
                                  message: message,
                                  isMe: isMe,
                                ),
                              );
                            },
                          ),
                        ),
                ),

                // Message input
                MessageInput(
                  controller: _messageController,
                  onSend: _sendMessage,
                  isConnected: isConnected,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _chatBloc.add(ClearMessages());
    _chatBloc.close();
    super.dispose();
  }
}
