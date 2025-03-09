import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_densy_project/app/modules/profile/views/profile_view.dart';
import 'package:flutter_densy_project/app/utils/themeSwitcher.dart';
import '../../../controllers/theme_controller.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingController());
    final ThemeController _themeController = Get.put(ThemeController());
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: _themeController.isDarkMode.value ? Colors.white : Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ), 
          backgroundColor: _themeController.isDarkMode.value ? Colors.grey[900] : Colors.grey[100],
        ),
        backgroundColor: _themeController.isDarkMode.value ? Colors.grey[900] : Colors.grey[100],
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 18,
                    color: _themeController.isDarkMode.value ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _themeController.isDarkMode.value ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Get.to(ProfileView());
                },
                child: Obx(() {
                  return Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _themeController.isDarkMode.value ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage('https://avatar.iran.liara.run/public'),
                          radius: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller.userData.isNotEmpty
                              ? "Hi,  ${controller.userData["profile"]["name"]?.toString() ?? "Unknown"}"
                              : "No User Data",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _themeController.isDarkMode.value ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(height: 16),
              // Dark Mode Toggle
              ThemeToggleRow(),
              SizedBox(height: 16),
              // Logout Button
              GestureDetector(
                onTap: () {
                  controller.logout();
                },
                child: Obx(() {
                  return Row(
                    children: [
                      Icon(
                        Icons.logout,
                        size: 36,
                        color: _themeController.isDarkMode.value ? Colors.white : Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _themeController.isDarkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }
}