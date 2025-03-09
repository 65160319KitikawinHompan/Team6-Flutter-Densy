import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/controllers/theme_controller.dart';
import 'package:get/get.dart';

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

class ProfileInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;

  const ProfileInputField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false, 
    required this.hint, 
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController = Get.put(ThemeController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _themeController.isDarkMode.value ? Colors.white : Colors.black)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText, 
          style: TextStyle(
            color: _themeController.isDarkMode.value ? Colors.white : Colors.black, fontWeight: FontWeight.bold
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: _themeController.isDarkMode.value ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: _themeController.isDarkMode.value ? Colors.grey[800] : Colors.grey[200],
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}