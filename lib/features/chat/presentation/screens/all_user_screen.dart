import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widget/user_item_widget.dart';

class AllUsersScreen extends StatefulWidget {
  final String currentUserId;

  const AllUsersScreen({
    super.key,
    required this.currentUserId,
  });

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetAllUsersEvent(userId: widget.currentUserId));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        elevation: 1,
      ),
      body: Expanded(
        child: BlocConsumer<ChatBloc, ChatState>(
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

            if (state is AllUsersLoaded) {
              // Filter users based on search query and exclude current user
              final filteredUsers = state.users
                  .where((user) =>
              user.uid != widget.currentUserId &&
                  (_searchQuery.isEmpty ||
                      user.name.toLowerCase().contains(_searchQuery) ||
                      user.email.toLowerCase().contains(_searchQuery)))
                  .toList();

              if (filteredUsers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _searchQuery.isNotEmpty ? Icons.search_off : Icons.people_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchQuery.isNotEmpty ? 'No users found' : 'No users available',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (_searchQuery.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search term',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredUsers.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return UserItemWidget(
                    user: user,
                    currentUserId: widget.currentUserId,
                  );
                },
              );
            }

            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }
}