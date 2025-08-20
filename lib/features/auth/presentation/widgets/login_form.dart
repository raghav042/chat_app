import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../widget/custom_input_field.dart';
import '../../../../widget/primary_button.dart';

class LoginForm extends StatefulWidget {
  final String actionButtonText;
  final VoidCallback onSubmit;
  final VoidCallback onToggle;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final bool isLogin;

  const LoginForm({
    super.key,
    this.actionButtonText = '',
    required this.onSubmit,
    required this.onToggle,
    required this.emailController,
    required this.passwordController,
    this.isLoading = false,
    this.isLogin = true,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      child: Column(
        children: [
          SizedBox(height: 50),
          SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomInputField(
                    label: AppStrings.email,
                    icon: Icons.email_outlined,
                    controller: widget.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 18),
                  CustomInputField(
                    label: AppStrings.password,
                    icon: Icons.lock_outline,
                    controller: widget.passwordController,
                    isObscure: true,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 35),
                  PrimaryButton(
                    text: widget.actionButtonText,
                    isLoading: widget.isLoading,
                    onPressed: widget.onSubmit,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.isLogin
                          ? AppStrings.dontHaveAnAccount
                          : AppStrings.alreadyHaveAnAccount),
                      TextButton(
                          onPressed: widget.onToggle,
                          child: Text(widget.isLogin
                              ? AppStrings.register
                              : AppStrings.login)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
