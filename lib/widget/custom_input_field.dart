import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final TextEditingController? controller;
  final bool isObscure;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  const CustomInputField({
    super.key,
    required this.label,
    this.icon,
    this.controller,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    required this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
