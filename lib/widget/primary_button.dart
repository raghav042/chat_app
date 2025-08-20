// lib/widget/primary_button.dart

import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 58),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
          : Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}