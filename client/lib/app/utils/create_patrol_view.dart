import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/modules/patrol/controllers/patrol_controller.dart';
import 'package:get/get.dart';

String? selectedPreset;
DateTime selectedDate = DateTime.now();
late List<dynamic> presetChecklists;
int? selectedPresetId;


class PatrolPresetPage extends StatefulWidget {
  @override
  _PatrolPresetPageState createState() => _PatrolPresetPageState();
}

class _PatrolPresetPageState extends State<PatrolPresetPage> {
  final controller = Get.find<PatrolController>();
  late List<Map<String, dynamic>> presets;

  @override
  void initState() {
    super.initState();  
    presets = controller.presetsData
      .map<Map<String, dynamic>>((preset) => {
        'id': preset['id'],   
        'title': preset['title'],
        'checklists': preset['presetChecklists']
      }).cast<Map<String, dynamic>>()
    .toList();  
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(45),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Patrol Preset",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "Please select a preset for the patrol",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 16),
              // แสดงตัวเลือกพรีเซ็ตจาก API
              SizedBox(
                height: 219,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (presets.isNotEmpty)
                    ...presets.map((preset) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPreset = preset["title"];
                            selectedPresetId = preset["id"];
                            presetChecklists = preset['checklists'];
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: selectedPreset == preset["title"] ? Colors.grey[850] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              preset["title"],
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: selectedPreset == preset["title"] ? Colors.white : Colors.grey[850],),
                            ),
                          )
                        ),
                      );
                    }).toList()
                  else
                    Center(child: Text("No presets available")),
                    ],
                  ),
                )
              ),
              SizedBox(height: 16),
              // Date Picker
              Text("Date", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
              SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "${selectedDate.day.toString().padLeft(2, '0')}/"
                        "${selectedDate.month.toString().padLeft(2, '0')}/"
                        "${selectedDate.year}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, size: 20),
                    color: Colors.black,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      minimumSize: Size(85, 45), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)), 
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedPreset == null) {
                        Get.snackbar("Failed", "Please Select Prestet");
                      }else {
                        Get.to(PatrolChecklistPage());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(165, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Next",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8), 
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


class PatrolChecklistPage extends StatefulWidget {
  @override
  _PatrolChecklistPageState createState() => _PatrolChecklistPageState();
}

class _PatrolChecklistPageState extends State<PatrolChecklistPage> {
  final controller = Get.find<PatrolController>();
  late List<Map<String, dynamic>> checklists;

  @override
  void initState() {
    super.initState();

    checklists = presetChecklists
      .map<Map<String, dynamic>>((checklist) => {
        'id': checklist['checklistId'],   
        'title':  checklist['checklist']['title'],
      }).cast<Map<String, dynamic>>()
    .toList();  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child:  SingleChildScrollView( 
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(45),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Patrol Preset",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Please select a preset for the patrol",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text("Date", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "${selectedDate.day.toString().padLeft(2, '0')}/"
                          "${selectedDate.month.toString().padLeft(2, '0')}/"
                          "${selectedDate.year}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("Checklist", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                  SizedBox(height: 8),
                  // แสดงตัวเลือกพรีเซ็ตจาก API
                  SizedBox(
                    height: 280,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (checklists.isNotEmpty)
                            Column(
                              children: checklists.map((checklist) {
                                return Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        checklist["title"],
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[850]),
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.symmetric(vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage("https://avatar.iran.liara.run/public"),
                                              radius: 20,
                                              backgroundColor: Colors.grey[300],
                                            ),
                                            SizedBox(width: 10),
                                            Obx(() {
                                              if (controller.userData.isNotEmpty) {
                                                return Text(
                                                  controller.userData["profile"]["name"]?.toString() ?? "Unknown",
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                                );
                                              } else {
                                                return Text("No User Data", style: TextStyle(fontSize: 16, color: Colors.red));
                                              }
                                            }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                          else
                            Center(child: Text("No presets available")),
                        ],
                      )
                    )
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, size: 20),
                        color: Colors.black,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          minimumSize: Size(85, 45), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)), 
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          List<Map<String, int>> formattedChecklists = checklists.map((checklist) {
                            return {
                              'checklistId': checklist['id'] as int,
                              'userId': controller.userData.isNotEmpty ? controller.userData['id'] as int : 0,
                            };
                          }).toList();

                          controller.postPatrol(
                            selectedDate.toIso8601String() + "Z",
                            selectedPresetId!,
                            formattedChecklists,
                          );
                          
                          Get.offAllNamed('/patrol');
                        },
                        icon: Icon(Icons.note_add_outlined, color: Colors.white, size: 24),
                        label: Text("New Patrol", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: Size(85, 50), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.grey), 
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
