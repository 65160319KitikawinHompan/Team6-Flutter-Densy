import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_densy_project/app/modules/patrol/controllers/patrol_controller.dart';
import 'package:flutter_densy_project/app/utils/patrol_card.dart';

class PatrolListView extends StatelessWidget {
  const PatrolListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<PatrolController>();

      if (controller.patrolsData.isEmpty) {
        return const Center(child: Text("No Patrol"));
      }

      return SingleChildScrollView(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.start,
          children: controller.patrolsData.map<Widget>((patrol) {
            final status = patrol["status"] as String;
            final date = DateTime.parse(patrol["date"]);
            final presetTitle = patrol["preset"]["title"] as String;
            final inspectors = patrol["inspectors"] as List;
            final inspector = inspectors[0];
            final imageData = inspector["profile"]["image"];
            final avatarUrl = (imageData != null)
                ? "http://localhost:4000/uploads/${imageData["path"]}"
                : "https://i.pravatar.cc/300";

            return PatrolCard(
              status: status,
              date: date,
              presetTitle: presetTitle,
              inspectorAvatarUrl: avatarUrl,
            );
          }).toList(),
        ),
      );
    });
  }
}
