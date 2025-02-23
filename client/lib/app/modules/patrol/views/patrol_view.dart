import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/utils/button.dart';
import 'package:get/get.dart';
import '../controllers/patrol_controller.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PatrolView is working',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            SubmitButton(
              title: "Sign Out",
              onPressed: controller.logout,
            )
          ],
        ),
      ),
    );
  }
}
