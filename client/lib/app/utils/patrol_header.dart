import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/controllers/theme_controller.dart';
import 'package:flutter_densy_project/app/modules/patrol/controllers/patrol_controller.dart';
import 'package:get/get.dart';

class PatrolHeader extends StatefulWidget {
  @override
  _PatrolHeaderState createState() => _PatrolHeaderState();
}

class _PatrolHeaderState extends State<PatrolHeader> {
  final controller = Get.find<PatrolController>();
  final ThemeController _themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, 
          end: Alignment.bottomCenter, 
          colors: <Color>[
            Color(0xFFEF4444), 
            Color(0xFF9747FF), 
          ],
          stops: [0.0, 1.0], 
          tileMode: TileMode.clamp,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(100),
          
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 60,
              decoration: BoxDecoration(
                color: _themeController.isDarkMode.value
                    ? Colors.grey[900]
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    return Text(
                      controller.userData.isNotEmpty
                          ? "Hi,  ${controller.userData["profile"]["name"]?.toString() ?? "Unknown"}"
                          : "No User Data",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: controller.userData.isNotEmpty
                            ? _themeController.isDarkMode.value
                                ? Colors.white
                                : Colors.black
                            : Colors.red,
                      ),
                    );
                  }),
                  SizedBox(width: 35),
                  CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        NetworkImage("http://localhost:4000/uploads/${controller.userImage}", scale: 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
