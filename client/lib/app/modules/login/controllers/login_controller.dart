import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;
  final Dio dio = Dio();

  Future<void> login() async {
    isLoading.value = true;

    try {
      var response = await dio.post(
        "http://localhost:4000/api/login",
        data: {
          "username": usernameController.text,
          "password": passwordController.text,
        },
      );

      print("Request successful: Status ${response.toString()}");

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Login Successful");
        Get.offAllNamed(Routes.HOME);
        print("Success Login Successful");
      } else {
        Get.snackbar("Error", "Invalid credentials");
        print("Error Invalid credentials");
      }
    } catch (e) {
      Get.snackbar("Error", "Login failed: $e");
      print("Error fetch");
    } finally {
      isLoading.value = false;
    }
  }
}
