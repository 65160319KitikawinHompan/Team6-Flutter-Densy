import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../themes/app_themes.dart'; // Import your themes

class ThemeController extends GetxController {
  final GetStorage _box = GetStorage();
  var isDarkMode = false.obs; // Observable boolean for dark mode

  @override
  void onInit() {
    super.onInit();
    // Load saved theme preference from storage
    isDarkMode.value = _box.read('isDarkMode') ?? false;
  }

  // Get the current theme based on the mode
  ThemeData get theme => isDarkMode.value ? AppThemes.darkTheme : AppThemes.lightTheme;

  // Toggle between light and dark mode
  void toggleTheme() {
    isDarkMode.toggle();
    _box.write('isDarkMode', isDarkMode.value); // Save preference to storage
    Get.changeTheme(theme); // Update the app theme globally
  }
}