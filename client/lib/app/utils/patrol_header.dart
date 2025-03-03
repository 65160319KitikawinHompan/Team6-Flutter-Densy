import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/modules/patrol/controllers/patrol_controller.dart';
import 'package:get/get.dart';

class PatrolHeader extends StatefulWidget {
  @override
  _PatrolHeaderState createState() => _PatrolHeaderState();
}

class _PatrolHeaderState extends State<PatrolHeader> {
  final controller = Get.find<PatrolController>();

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
            Color.fromARGB(255, 233, 0, 136),
            Color.fromARGB(255, 197, 37, 162),
            Color.fromARGB(255, 121, 0, 99),
          ],
          tileMode: TileMode.mirror,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(100),
        ),
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
                color: Colors.white,
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
                            ? Colors.black87
                            : Colors.red,
                      ),
                    );
                  }),
                  SizedBox(width: 35),
                  CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        NetworkImage("https://avatar.iran.liara.run/public"),
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
