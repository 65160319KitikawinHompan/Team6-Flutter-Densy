import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/patrol_controller.dart';
import 'package:flutter_densy_project/app/utils/patrol_card.dart';
import 'package:flutter_densy_project/app/utils/patrol_list_view.dart'; // นำเข้า Widget ใหม่

class PatrolView extends GetView<PatrolController> {
  const PatrolView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PatrolController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('PatrolView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ปุ่ม New Patrol
            NewPatrolButton(
              onPressed: () {
                controller.fetchData();
              },
            ),
            const SizedBox(height: 20),
            // ใช้ PatrolListView 
            const Expanded(child: PatrolListView()),
          ],
        ),
      ),
    );
  }
}
