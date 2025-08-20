import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/connectivity/connectivity_bloc.dart';
import 'core/di/di.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_names.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'widget/no_internet_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Providing the AuthBloc
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        // Providing the ConnectivityBloc to the widget tree
        BlocProvider<ConnectivityBloc>(create: (_) => sl<ConnectivityBloc>()),
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
              // TODO: Return your main application screen, e.g., HomeScreen()
              // For now, returning a placeholder.
              return const Scaffold(
                body: Center(
                  child: Text('Authenticated! Navigating to Home...'),
                ),
              );
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
