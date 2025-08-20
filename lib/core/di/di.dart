import 'package:chat_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:chat_app/features/chat/data/models/chat_model.dart';
import 'package:chat_app/features/message/data/models/message_model.dart';
import 'package:chat_app/features/profile/data/datasources/local/profile_local_datasource.dart';
import 'package:chat_app/features/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:chat_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:chat_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:chat_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecase/logout_usecase.dart';
import '../../features/chat/data/datasources/local/chat_local_datasource.dart';
import '../../features/chat/data/datasources/remote/chat_remote_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/get_chat_users_usecase.dart';
import '../../features/chat/domain/usecases/get_users_usecase.dart';
import '../../features/chat/presentation/bloc/chat_bloc.dart';
import '../../features/message/data/datasource/local/message_local_datasource.dart';
import '../../features/message/data/datasource/remote/message_remote_datasource.dart';
import '../../features/message/data/repository/message_repository_impl.dart';
import '../../features/message/domain/repository/message_repository.dart';
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

import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../connectivity/connectivity_bloc.dart';
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
      registerUseCase: sl(),
      loginUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // Register ConnectivityBloc
  sl.registerFactory(() => ConnectivityBloc(sl()));

  // Register ChatBloc
  sl.registerFactory(
        () => ChatBloc(
      getAllUsersUseCase: sl(),
      getAllChatUsersUseCase: sl(),
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
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // Chat Use cases
  sl.registerLazySingleton(() => GetAllUsersUseCase(sl()));
  sl.registerLazySingleton(() => GetAllChatUsersUseCase(sl()));

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

  // Message Repository
  sl.registerLazySingleton<MessageRepository>(
        () => MessageRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Profile Repository
  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Auth Data sources
  sl.registerLazySingleton<AuthDataSource>(
        () => AuthDataSourceImpl(auth: sl(), firestore: sl()),
  );

  // Chat Data sources
  sl.registerLazySingleton<ChatLocalDataSource>(
        () => ChatLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
        () => ChatRemoteDataSourceImpl(sl()),
  );

  // Message Data sources
  sl.registerLazySingleton<MessageRemoteDataSource>(
        () => MessageRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<MessageLocalDataSource>(
        () => MessageLocalDataSourceImpl(sl()),
  );

  // Profile Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
        () => ProfileLocalDataSourceImpl(sl()),
  );
}