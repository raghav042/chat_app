// lib/features/auth/presentation/bloc/widgets/register_form.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../widget/custom_input_field.dart';
import '../../../../widget/primary_button.dart';

class RegisterForm extends StatelessWidget {
  final String actionButtonText;
  final VoidCallback onSubmit;
  final VoidCallback onToggle;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final bool isLogin;

  const RegisterForm({
    super.key,
    required this.actionButtonText,
    required this.onSubmit,
    required this.onToggle,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.isLoading = false,
    this.isLogin = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          SizedBox(height: 50),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  CustomInputField(
                    label: AppStrings.name,
                    icon: Icons.person,
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 18),
                  CustomInputField(
                    label: AppStrings.email,
                    icon: Icons.email_outlined,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 18),
                  CustomInputField(
                    label: AppStrings.password,
                    icon: Icons.lock_outline,
                    controller: passwordController,
                    isObscure: true,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 18),
                  CustomInputField(
                    label: AppStrings.confirmPassword,
                    icon: Icons.lock_outline,
                    controller: confirmPasswordController,
                    isObscure: true,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 32),
                  PrimaryButton(
                    text: actionButtonText,
                    isLoading: isLoading,
                    onPressed: onSubmit,
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: onToggle,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: isLogin
                                ? AppStrings.dontHaveAnAccount
                                : AppStrings.alreadyHaveAnAccount,
                          ),
                          TextSpan(
                            text: isLogin
                                ? AppStrings.register
                                : AppStrings.login,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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
