import 'package:flutter/material.dart';
class InputTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;

  const InputTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false, // Default: not hiding text
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText, 
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}

