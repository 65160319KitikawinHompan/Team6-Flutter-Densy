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
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: _themeController.isDarkMode.value ? Colors.white : Colors.black),
            onPressed: () => Get.toNamed('/setting'),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          // Name Field
                          Obx(() => ProfileInputField(
                            label: "Name",
                            hint: controller.userData?["profile"]?["name"]?.toString() ?? "N/A",
                            controller: controller.nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                            themeController: _themeController
                          )),
                          SizedBox(height: 16),
                          // Email Field
                          Obx(() => ProfileInputField(
                            label: "Email",
                            hint: controller.userData?["email"]?.toString() ?? "N/A",
                            controller: controller.emailController,
                            validator: (value) {
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!) && value.isNotEmpty) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                            themeController: _themeController
                          )),
                          SizedBox(height: 16),
                          // Age Field
                          Obx(() => ProfileInputField(
                            label: "Age",
                            hint: controller.userData?["profile"]?["age"]?.toString() ?? "N/A",
                            controller: controller.ageController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your age";
                              } else if (int.tryParse(value) == null || int.parse(value) <= 0 || int.parse(value) > 60) {
                                return "Enter a valid age (1-60)";
                              }
                              return null;
                            },
                            themeController: _themeController
                          )),
                          SizedBox(height: 16),
                          // Phone Field
                          Obx(() => ProfileInputField(
                            label: "Phone",
                            hint: controller.userData?["profile"]?["tel"]?.toString() ?? "N/A",
                            controller: controller.phoneController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your phone number";
                              } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                return "Enter a valid phone number (10 digits)";
                              }
                              return null;
                            },
                            themeController: _themeController
                          )),
                          SizedBox(height: 16),
                          // Address Field
                          Obx(() => ProfileInputField(
                            label: "Address",
                            hint: controller.userData?["profile"]?["address"]?.toString() ?? "N/A",
                            controller: controller.addressController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your address";
                              }
                              return null;
                            },
                            themeController: _themeController
                          )),
                          SizedBox(height: 28),
                          SaveButton(
                            title: "Save",
                            onPressed: controller.updateProfile,
                            themeController: _themeController
                          )
                        ],
                      ),
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      );
    });
  }
}
