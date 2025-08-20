import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_chat_users_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetAllUsersUseCase _getAllUsersUseCase;
  final GetAllChatUsersUseCase _getAllChatUsersUseCase;

  ChatBloc({
    required GetAllUsersUseCase getAllUsersUseCase,
    required GetAllChatUsersUseCase getAllChatUsersUseCase,
  })  : _getAllUsersUseCase = getAllUsersUseCase,
        _getAllChatUsersUseCase = getAllChatUsersUseCase,
        super(ChatInitial()) {
    on<GetAllUsersEvent>(_onGetAllUsers);
    on<GetAllChatUsersEvent>(_onGetAllChatUsers);
    on<RefreshChatsEvent>(_onRefreshChats);
  }

  Future<void> _onGetAllUsers(
      GetAllUsersEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      emit(ChatLoading());
      final users = await _getAllUsersUseCase.execute(event.userId);
      emit(AllUsersLoaded(users: users));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  Future<void> _onGetAllChatUsers(
      GetAllChatUsersEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      emit(ChatLoading());
      final chats = await _getAllChatUsersUseCase.execute(event.userId);
      emit(AllChatUsersLoaded(chats: chats));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  Future<void> _onRefreshChats(
      RefreshChatsEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      // Get current state for optimistic UI
      final currentState = state;
      if (currentState is AllChatUsersLoaded) {
        emit(ChatRefreshing(currentChats: currentState.chats));
      }

      final chats = await _getAllChatUsersUseCase.execute(event.userId);
      emit(AllChatUsersLoaded(chats: chats));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }
}