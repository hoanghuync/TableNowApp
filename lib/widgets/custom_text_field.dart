import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.controller, required this.label, this.validator, this.keyboardType, this.obscureText = false, this.maxLines = 1, this.icon});

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, prefixIcon: icon == null ? null : Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)), filled: true),
    );
  }
}
