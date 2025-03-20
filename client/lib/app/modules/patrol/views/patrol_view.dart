import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/controllers/theme_controller.dart';
import 'package:flutter_densy_project/app/utils/navbar.dart';
import 'package:flutter_densy_project/app/utils/patrol_header.dart';
import 'package:get/get.dart';
import '../controllers/patrol_controller.dart';
import 'package:flutter_densy_project/app/utils/patrol_card.dart';

/// หน้าจอหลักสำหรับการแสดงรายการ Patrol ทั้งหมด
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
            /// ส่วนหัวแบบไล่สี
            PatrolHeader(),
            /// กล่องค้นหา
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 14, top: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: _themeController.isDarkMode.value
                      ? Colors.grey[800]
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.only(left: 0, right: 12),
                child: TextField(
                  style: TextStyle(
                    color: _themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (query) => controller.searchPatrols(query),
                  decoration: InputDecoration(
                    hintText: "What do you want to search?",
                    hintStyle: TextStyle(
                      color: _themeController.isDarkMode.value
                          ? Colors.grey[200]
                          : Colors.grey[800],
                    ),
                    prefixIcon: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color(0xFFB2FF00),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.search,
                        color: _themeController.isDarkMode.value
                            ? Colors.grey[200]
                            : Colors.grey[800],
                      ),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  ),
                ),
              ),
            ),

            // Start Patrol Text
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, top: 12), 
              child: Align(
                alignment: Alignment.centerLeft, 
                child: Text(
                  'Start Patrol',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
            ),

            /// ใช้ Wrap รวมปุ่ม NewPatrolButton และรายการ Patrol
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Wrap(
                  spacing: 10, // ระยะห่างระหว่าง Patrol Card
                  runSpacing: 10, // ระยะห่างระหว่างบรรทัด
                  alignment: WrapAlignment.start, // จัดเรียงจากซ้ายไปขวา
                  crossAxisAlignment: WrapCrossAlignment
                      .start, // จัด widget ให้อยู่ในแนวเดียวกัน
                  children: [
                    ///  ใส่ NewPatrolButton ใน Wrap โดยตรง
                    NewPatrolButton(
                      onPressed: () {
                        controller.createPatrolView();
                      },
                    ),

                    /// เพิ่ม PatrolListView แบบตรงไปตรงมาใน Wrap เดียวกัน
                    ...controller.filteredPatrols.map((patrol) {
                      final status = patrol["status"] as String;
                      final date = DateTime.parse(patrol["date"]);
                      final presetTitle = patrol["preset"]["title"] as String;
                      final inspectors = patrol["inspectors"] as List;
                      final inspector =
                          inspectors.isNotEmpty ? inspectors[0] : {};
                      final imageData = inspector?["profile"]?["image"];
                      final avatarUrl = imageData != null
                          ? "http://localhost:4000/uploads/${imageData["path"]}"
                          : "https://i.pravatar.cc/300";

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            '/patrol/detail/${patrol["id"]}',
                            arguments:
                                patrol, // ส่งข้อมูล patrol ที่ถูกเลือกไปยังหน้า DetailView
                          );
                        },
                        child: PatrolCard(
                          status: status,
                          date: date,
                          presetTitle: presetTitle,
                          inspectorAvatarUrl: avatarUrl,
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            /// แถบเมนูด้านล่าง
            CustomNavBar(),
            const SizedBox(height: 30),
          ],
        ),
      );
    });
  }
}
