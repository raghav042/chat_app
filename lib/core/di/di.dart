import 'package:chat_app/features/chat/data/models/chat_model.dart';
import 'package:chat_app/features/message/data/models/message_model.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecase/logout_usecase.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/message/data/datasource/local/message_local_datasource.dart';
import '../../features/message/data/datasource/remote/message_remote_datasource.dart';
import '../../features/message/data/repository/message_repository_impl.dart';
import '../../features/message/domain/usecase/delete_message_usecase.dart';
import '../../features/message/domain/usecase/get_messages_usecase.dart';
import '../../features/message/domain/usecase/send_message_usecase.dart';
import '../../features/message/domain/usecase/update_message_usecase.dart';
import '../../features/message/presentation/bloc/chat_bloc.dart';
import '../../features/profile/data/models/profile_model.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/usecase/login_usecase.dart';
import '../../features/auth/domain/usecase/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../connectivity/connectivity_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Hive boxes
  final userBox = await Hive.openBox<ProfileModel>('users');
  final chatBox = await Hive.openBox<ChatModel>('chats');
  final messageBox = await Hive.openBox<MessageModel>('messages');
  final cacheBox = await Hive.openBox('cache');

  sl.registerLazySingleton<Box<ProfileModel>>(() => userBox);
  sl.registerLazySingleton<Box<ChatModel>>(() => chatBox);
  sl.registerLazySingleton<Box<MessageModel>>(() => messageBox);
  sl.registerLazySingleton<Box>(() => cacheBox);

  // BLoCs
  sl.registerFactory(
    () => AuthBloc(
      loginUserUseCase: sl(),
      registerUserUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => MessageBloc(
      sendMessageUseCase: sl(),
      getMessagesUseCase: sl(),
      updateMessageUseCase: sl(),
      deleteMessageUseCase: sl(),
    ),
  );

  // Auth Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Message Use cases
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetMessagesUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMessageUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMessageUseCase(sl()));

  // Profile Use cases
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  sl.registerLazySingleton(() => GetLastMessageUseCase(sl()));

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authDataSource: sl(),
      profileRemoteDataSource: sl(),
      profileLocalDataSource: sl(),
    ),
  );

  // Chat Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      chatLocalDataSource: sl(),
      chatRemoteDataSource: sl(),
      messageRemoteDataSource: sl(),
      profileRemoteDataSource: sl(),
    ),
  );

  // Users Repository
  sl.registerLazySingleton<UsersRepository>(
    () => UsersRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Auth Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(auth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sl()),
  );

  // Chat Data sources
  sl.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<MessageLocalDataSource>(
    () => MessageLocalDataSourceImpl(sl()),
  );

  // Users Data sources
  sl.registerLazySingleton<UsersRemoteDataSource>(
    () => UsersRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<UsersLocalDataSource>(
    () => UsersLocalDataSourceImpl(sl()),
  );
}
