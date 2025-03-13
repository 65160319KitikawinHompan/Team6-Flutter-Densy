import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/controllers/theme_controller.dart';
import 'package:flutter_densy_project/app/utils/navbar.dart';
import 'package:flutter_densy_project/app/utils/patrol_header.dart';
import 'package:get/get.dart';
import '../controllers/patrol_controller.dart';
import 'package:flutter_densy_project/app/utils/patrol_card.dart';
import 'package:flutter_densy_project/app/utils/patrol_list_view.dart';

class PatrolView extends GetView<PatrolController> {
  const PatrolView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController = Get.put(ThemeController());
    return Obx(() {
      return Scaffold(
      backgroundColor: _themeController.isDarkMode.value ? Colors.grey[900] : Colors.grey[100],
      body: Column(
          children: [
            PatrolHeader(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: _themeController.isDarkMode.value ? Colors.grey[800] : Colors.grey[300], 
                  borderRadius: BorderRadius.circular(12), 
                ),
                padding: EdgeInsets.symmetric(horizontal: 12), 
                child: TextField(
                  style: TextStyle(
                    color: _themeController.isDarkMode.value ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (query) => controller.searchPatrols(query),
                  decoration: InputDecoration(
                    hintText: "What do you want to search?",
                    hintStyle: TextStyle(
                      color: _themeController.isDarkMode.value ? Colors.grey[200] : Colors.grey[800],
                    ),
                    prefixIcon: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.search,
                        color: _themeController.isDarkMode.value ? Colors.grey[200] : Colors.grey[800],
                      ),
                    ),
                    border: InputBorder.none, 
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            // ปุ่ม New Patrol
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: NewPatrolButton(
                onPressed: () {
                  controller.createPatrolView();
                },
              ),
            ),
            const SizedBox(height: 10),
            // ใช้ PatrolListView 
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: PatrolListView(),
              ),
            ),
            CustomNavBar(),
            const SizedBox(height: 30),
          ],
        ),
      );
    });
  }
}
