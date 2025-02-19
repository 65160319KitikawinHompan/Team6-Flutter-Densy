import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/button.dart';
import '../../../utils/input_field.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              Text(
                'Enter your username and password to login to your account',
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    InputTextField(
                      label: "Username",
                      controller: controller.usernameController,
                    ),
                    SizedBox(height: 15),
                    InputTextField(
                      label: "Password",
                      controller: controller.passwordController,
                      obscureText: true, 
                    ),
                    SizedBox(height: 15),
                    Obx(
                      () => SubmitButton(
                        title: controller.isLoading.value ? "Loading..." : "Login",
                        onPressed: controller.isLoading.value ? null : controller.login,
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
