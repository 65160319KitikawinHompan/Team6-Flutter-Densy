import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/modules/login/views/login_view.dart';
import 'package:flutter_densy_project/app/utils/button.dart';

import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment(0.4, 0.2),
              colors: <Color>[
                Color.fromARGB(255, 255, 255, 255),
                Color(0xffac255e),
                Color(0xffca485c),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 50),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 40),
                const Image(
                  image: AssetImage(
                    'assets/DensyLogo.png', 
                  ),
                  width: 177.31,
                  height: 55.59,
                ),
              ]),
              const Image(
                image: AssetImage(
                  'assets/DensyMascos.png', 
                ),
                width: 487,
                height: 337,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(48),
                        topRight: Radius.circular(48),
                      ),
                    ),
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GradientText(
                          'Easy patrol your\nFactory with\nRealtime system',
                          style: TextStyle(
                              fontSize: 40.0, fontWeight: FontWeight.bold),
                          gradientType: GradientType.linear,
                          gradientDirection: GradientDirection.ttb,
                          radius: .4,
                          colors: [
                            Color.fromARGB(255, 229, 86, 108),
                            Color(0xffca485c),
                            Color(0xffac255e),
                          ],
                        ),
                        const SizedBox(height: 20),
                        NextPageButton(
                            title: "Explore Now →",
                            onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginView(),
                                  ),
                                ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
