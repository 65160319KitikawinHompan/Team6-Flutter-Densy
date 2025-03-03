import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Column(
        children: [
          PatrolHeader(),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) => controller.searchPatrols(query),
              decoration: InputDecoration(
                hintText: "What do you want to search?",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
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
  }
}
