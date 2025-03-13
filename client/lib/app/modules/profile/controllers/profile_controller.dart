import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final dio = Dio();
  var userData = <String, dynamic>{}.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> fetchUserData() async {
    try {
      final box = GetStorage();
      String? accessToken = box.read('token');
      int userId = box.read('userId');

      if (accessToken == null) {
        print("Error: Access Token is missing.");
        return;
      }

      var response = await dio.get(
        "http://localhost:4000/api/user/$userId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      userData.value = response.data; 
      
      nameController.text = userData['profile']?['name'] ?? '';
      emailController.text = userData['email'] ?? '';
      ageController.text = userData['profile']?['age']?.toString() ?? '';
      phoneController.text = userData['profile']?['tel'] ?? '';
      addressController.text = userData['profile']?['address'] ?? '';
      } else {
        print("Error: Unexpected response format");
      }
    } catch (e) {
      print("Fetch user Error: $e");
    }
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) {
      return; 
    }

    try {
      final box = GetStorage();
      String? accessToken = box.read('token');
      int userId = box.read('userId');

      if (accessToken == null) {
        print("Error: Access Token is missing.");
        return;
      }
      
      var response = await dio.put(
        "http://localhost:4000/api/user/$userId",
        data: {
          "name": nameController.text,
          "email": emailController.text,
          "age": ageController.text,
          "tel": phoneController.text,
          "address": addressController.text
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        )
      );
      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar("Success", "Update Profile Successful");
      } else {
        Get.snackbar("Error", "Fail to Update Profile");
      }
    } catch (e) {
      Get.snackbar("Fail to Update", "Update Profile failed : Invalid Input Data");
    }
  }


}
