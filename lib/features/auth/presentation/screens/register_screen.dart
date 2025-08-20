// lib/features/auth/presentation/bloc/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/route_names.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppStrings.registrationSuccessful)),
              );
              Navigator.pushNamed(context, RouteNames.login);
            }
          },
          builder: (context, state) {
            return RegisterForm(
              actionButtonText: AppStrings.register,
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
              isLogin: false,
              isLoading: state is AuthLoading,
              onSubmit: () {
                context.read<AuthBloc>().add(RegisterSubmitted(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      confirmPassword: confirmPasswordController.text.trim(),
                    ));
              },
              onToggle: () {
                Navigator.pushNamed(context, RouteNames.login);
              },
            );
          },
        ),
      ),
    );
  }
}
