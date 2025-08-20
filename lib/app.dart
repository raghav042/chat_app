import 'package:chat_app/widget/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/di.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_names.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/screens/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
      ],
      child: MaterialApp(
        builder: (context, child) {
          return Stack(
            children: [
              child ?? const SizedBox(),
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: NoInternetWidget(),
              ),
            ],
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: RouteNames.login,
        onGenerateRoute: AppRoutes.generateRoute,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is Authenticated) {
            } else if (state is Unauthenticated) {
              return LoginScreen();
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
