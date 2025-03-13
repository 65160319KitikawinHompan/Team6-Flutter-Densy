import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart'; 

class ThemeToggleRow extends StatelessWidget {
  final ThemeController _themeController = Get.find(); 

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          size: 10,
          color: _themeController.isDarkMode.value ? Colors.white : Colors.black,
        ),
        SizedBox(width: 8),
        Text(
          _themeController.isDarkMode.value ? "Dark mode" : "Light mode",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _themeController.isDarkMode.value ? Colors.white : Colors.black,
          ),
        ),
        Spacer(), // Add space between the text and the switch
        Obx(() => Switch(
          value: _themeController.isDarkMode.value,
          onChanged: (value) {
            _themeController.toggleTheme(); // Toggle the theme
          },
        )),
      ],
    );
  }
}