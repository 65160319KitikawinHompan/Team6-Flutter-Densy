import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/controllers/theme_controller.dart';

import 'package:get/get.dart';

class CustomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isPatrolView = ModalRoute.of(context)?.settings.name == '/patrol';
    final ThemeController _themeController = Get.put(ThemeController());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
        color:  _themeController.isDarkMode.value ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
             onTap: () {
              Get.toNamed('/patrol');
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPatrolView ? Colors.grey[300] : Colors.transparent, 
              ),
              padding: EdgeInsets.all(12),
              child: Icon(Icons.home_outlined, size: 32, color: _themeController.isDarkMode.value ? Colors.white : Colors.black87),
            ),
          ),
          GestureDetector(
             onTap: () {
              Get.toNamed('/setting');
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.blue, 
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              padding: EdgeInsets.all(10),
              child: Icon(Icons.settings, size: 32, color: _themeController.isDarkMode.value ? Colors.black87 : Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.grey[100], // Light background
      body: Center(child: CustomNavBar()), // Show NavBar in the center for preview
    ),
  ));
}
