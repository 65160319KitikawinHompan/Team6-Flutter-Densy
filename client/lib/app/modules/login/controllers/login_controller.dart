import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Dio dio = Dio();
  final box = GetStorage();

  Future<void> login() async {
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
        String accessToken = response.data['token'];
        int userId = response.data['userId'];
        
        box.write('token', accessToken);
        box.write('userId', userId);

        Get.snackbar("Success", "Login Successful");
        Get.offAllNamed(Routes.PATROL);
        print("Success Login Successful");
      } else {
        Get.snackbar("Error", "Invalid credentials");
        print("Error Invalid credentials");
      }
    } catch (e) {
      Get.snackbar("Fail to Login", "Login failed : Invalid Username Or Password");
      print("Error fetch");
    }
  }

  
}
