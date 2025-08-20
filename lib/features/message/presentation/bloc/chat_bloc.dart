import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecase/send_message_usecase.dart';
import '../../domain/usecase/get_messages_usecase.dart';
import '../../domain/usecase/update_message_usecase.dart';
import '../../domain/usecase/delete_message_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class MessageBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final UpdateMessageUseCase updateMessageUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;

  StreamSubscription<List<MessageEntity>>? _messagesSubscription;

  MessageBloc({
    required this.sendMessageUseCase,
    required this.getMessagesUseCase,
    required this.updateMessageUseCase,
    required this.deleteMessageUseCase,
  }) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<UpdateMessage>(_onUpdateMessage);
    on<DeleteMessage>(_onDeleteMessage);
    on<ClearMessages>(_onClearMessages);
    on<RefreshMessages>(_onRefreshMessages);
  }

  Future<void> _onLoadMessages(
      LoadMessages event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoading());

      await _messagesSubscription?.cancel();

      _messagesSubscription =
          getMessagesUseCase(event.currentUserId, event.otherUserId).listen(
        (messages) => emit(ChatLoaded(messages)),
        onError: (error) => emit(ChatError(error.toString())),
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    try {
      final currentMessages = state is ChatLoaded
          ? (state as ChatLoaded).messages
          : <MessageEntity>[];

      emit(MessageSending(currentMessages));

      final message = MessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: event.currentUserId,
        receiverId: event.receiverId,
        text: event.text,
        timestamp: DateTime.now(),
      );

      await sendMessageUseCase(message);

      // The stream subscription will automatically emit the updated state
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onUpdateMessage(
      UpdateMessage event, Emitter<ChatState> emit) async {
    try {
      final currentMessages = state is ChatLoaded
          ? (state as ChatLoaded).messages
          : <MessageEntity>[];

      final updatedMessage = MessageEntity(
        id: event.message.id,
        senderId: event.message.senderId,
        receiverId: event.message.receiverId,
        text: event.newText,
        timestamp: event.message.timestamp,
        isEdited: true,
      );

      await updateMessageUseCase(updatedMessage);

      // The stream subscription will automatically emit the updated state
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onDeleteMessage(
      DeleteMessage event, Emitter<ChatState> emit) async {
    try {
      await deleteMessageUseCase(
        event.message.id,
        event.message.senderId,
        event.message.receiverId,
      );

      // The stream subscription will automatically emit the updated state
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onClearMessages(ClearMessages event, Emitter<ChatState> emit) {
    _messagesSubscription?.cancel();
    emit(ChatInitial());
  }

  Future<void> _onRefreshMessages(
      RefreshMessages event, Emitter<ChatState> emit) async {
    // Force refresh by reloading messages
    add(LoadMessages(
        currentUserId: event.currentUserId, otherUserId: event.otherUserId));
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
