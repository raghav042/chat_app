// lib/features/auth/presentation/bloc/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/route_names.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.tropicalBlue,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }

            if (state is Authenticated) {
              // navigate to required screen
            }
          },
          builder: (context, state) {
            return LoginForm(
              actionButtonText: AppStrings.login,
              emailController: emailController,
              passwordController: passwordController,
              isLogin: true,
              isLoading: state is AuthLoading,
              onSubmit: () {
                context.read<AuthBloc>().add(LoginSubmitted(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    ));
              },
              onToggle: () {
                Navigator.pushNamed(context, RouteNames.register);
              },
            );
          },
        ),
      ),
    );
  }
}
