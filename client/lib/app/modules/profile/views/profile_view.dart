import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/controllers/theme_controller.dart';
import 'package:flutter_densy_project/app/utils/button.dart';
import 'package:flutter_densy_project/app/utils/input_field.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    final ThemeController _themeController = Get.put(ThemeController());
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _themeController.isDarkMode.value ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ), 
        backgroundColor: _themeController.isDarkMode.value ? Colors.grey[900] : Colors.grey[100],
      ),
      backgroundColor: _themeController.isDarkMode.value ? Colors.grey[900] : Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle, size: 18, color: _themeController.isDarkMode.value ? Colors.white : Colors.black),
                SizedBox(width: 8),
                Text("Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _themeController.isDarkMode.value ? Colors.white : Colors.black)),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Name Field
                  Obx(() => ProfileInputField(
                    label: "Name",
                    hint: controller.userData?["profile"]?["name"]?.toString() ?? "N/A",
                    controller: controller.nameController,
                  )),
                  SizedBox(height: 16),
                  // Email Field
                  Obx(() => ProfileInputField(
                    label: "Email",
                    hint: controller.userData?["email"]?.toString() ?? "N/A",
                    controller: controller.emailController,
                  )),
                  SizedBox(height: 16),
                  // Age Field
                  Obx(() => ProfileInputField(
                    label: "Age",
                    hint: controller.userData?["profile"]?["age"]?.toString() ?? "N/A",
                    controller: controller.ageController,
                  )),
                  SizedBox(height: 16),
                  // Phone Field
                  Obx(() => ProfileInputField(
                    label: "Phone",
                    hint: controller.userData?["profile"]?["tel"]?.toString() ?? "N/A",
                    controller: controller.phoneController,
                  )),
                  SizedBox(height: 16),
                  // Address Field
                  Obx(() => ProfileInputField(
                    label: "Address",
                    hint: controller.userData?["profile"]?["address"]?.toString() ?? "N/A",
                    controller: controller.addressController,
                  )),
                  SizedBox(height: 28),
                  SaveButton(
                    title: "Save",
                    onPressed: controller.updateProfile,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
