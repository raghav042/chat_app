import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_ce_flutter/adapters.dart';

import 'app.dart';
import 'core/di/di.dart';
import 'features/chat/data/models/chat_model.dart';
import 'features/message/data/models/message_model.dart';
import 'features/profile/data/models/profile_model.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(ProfileModelAdapter());
  Hive.registerAdapter(ChatModelAdapter());
  Hive.registerAdapter(MessageModelAdapter());

  // Initialize dependency injection
  await init();

  runApp(const MyApp());
}