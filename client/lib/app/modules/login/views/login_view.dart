import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/controllers/theme_controller.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../../utils/button.dart';
import '../../../utils/input_field.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    final ThemeController _themeController = Get.put(ThemeController());
    return Obx(() {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: const Alignment(0.4, 0.2),
              colors: <Color>[
                _themeController.isDarkMode.value ? Colors.black : Color.fromARGB(255, 255, 255, 255),
                const Color(0xffac255e),
                const Color(0xffca485c),
              ], // Gradient from https://learnui.design/tools/gradient-generator.html
              tileMode: TileMode.mirror,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 50),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 40),
                  Image(
                  image: 
                    AssetImage(
                      _themeController.isDarkMode.value ? 'assets/DarkDensyLogo.png' : 'assets/DensyLogo.png', 
                    ),
                    width: 177.31,
                    height: 55.59,
                  ),
                ]
              ),
              SizedBox(height: 20),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _themeController.isDarkMode.value ? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(48), 
                        topRight: Radius.circular(48),  
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Image(
                            image: 
                              AssetImage(
                                'assets/DensyMascos.png', 
                              ),
                            width: 487,
                            height: 337,
                          ),
                          GradientText(
                            'Login',
                            style: TextStyle(
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold
                            ),
                            gradientType: GradientType.linear,
                            gradientDirection: GradientDirection.ttb,
                            radius: 4,
                            colors: [
                              Color.fromARGB(255, 229, 86, 108),
                              Color(0xffca485c),
                              Color(0xffac255e),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                InputTextField(
                                  label: "Username",
                                  controller: controller.usernameController,
                                  themeController: _themeController,
                                ),
                                SizedBox(height: 15),
                                InputTextField(
                                  label: "Password",
                                  controller: controller.passwordController,
                                  obscureText: true, 
                                  themeController: _themeController,
                                ),
                                SizedBox(height: 15),
                                SubmitButton(
                                  title: "Sign In",
                                  onPressed: controller.login,
                                  themeController: _themeController
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
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
