import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/modules/detail/controllers/detail_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_densy_project/app/utils/navbar.dart';
import 'package:flutter_densy_project/app/utils/detail_tabbar.dart';
import 'package:flutter_densy_project/app/utils/checklist_card.dart';
import 'package:flutter_densy_project/app/utils/item_card.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final patrol = Get.arguments; // ข้อมูลจากหน้า PatrolView

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ชื่อ Patrol
            Text(
              patrol["preset"]["title"],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // สถานะ
            _buildStatusBadge(patrol["status"]),
            const SizedBox(height: 12),

            // แสดง TabBar กับปุ่ม Start
            Row(
              children: [
                DetailTabBar(
                  onTabChanged: (_) {
                 
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: SizedBox(
                    height: 48,
                    width: 100,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.startPatrolDetail();
                      },
                      icon: const Icon(Icons.autorenew, color: Colors.white, size: 18),
                      label: const Text(
                        "Start",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Checklist Card + Item Card
            Expanded(
              child: Obx(() {
                if (controller.patrolDetail.isEmpty) {
                  return const Center(child: Text("No data available"));
                }

                final checklists = controller.patrolDetail["patrolChecklists"] ?? [];

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: checklists.length,
                  itemBuilder: (context, index) {
                    final checklist = checklists[index];
                    final inspector = checklist["inspector"] ?? {};
                    final inspectorName = inspector["profile"]?["name"] ?? "Unknown Inspector";
                    final inspectorImage = inspector["profile"]?["image"] != null
                        ? "http://localhost:4000/uploads/${inspector["profile"]["image"]["path"]}"
                        : "https://i.pravatar.cc/300";

                    return ChecklistCard(
                      title: checklist["checklist"]["title"] ?? "Untitled Checklist",
                      inspectorName: inspectorName,
                      inspectorImage: inspectorImage,
                      statusColor: _getStatusColor(patrol["status"]),
                      children: _buildItemCards(checklist["checklist"]["items"] ?? [], patrol["status"]),
                    );
                  },
                );
              }),
            ),

            // NavBar ด้านล่าง
            CustomNavBar(),
          ],
        ),
      ),
    );
  }

 List<Widget> _buildItemCards(List<dynamic> items, String patrolStatus) {
  return items.map((item) {
    final itemId = item["id"];

    // Safeguard: Ensure patrolDetail["results"] is a list
    final resultList = controller.patrolDetail["results"] as List? ?? [];

    // Now we safely use firstWhere on the resultList
    final result = resultList.firstWhere(
      (resultItem) => resultItem["itemId"] == itemId,
      orElse: () => null,
    );

    // Safely access status: result can be null
    final status = result != null ? result["status"] : null; 

    print("Item ID: $itemId, Status: $status , $patrolStatus");

    return ItemCard(
      title: item["name"] ?? "Unnamed Item",
      type: item["type"] ?? "Unknown Type",
      hasReult: status ?? null,
      patrolStatus: patrolStatus,
    );
  }).toList();
}


  // สร้าง Badge สถานะ
  Widget _buildStatusBadge(String status) {
    String formattedStatus = _capitalizeFirstLetter(status);
    Color bgColor = _getStatusColor(status).withOpacity(0.2);
    Color textColor = _getStatusColor(status);
    IconData icon = _getStatusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 6),
          Text(
            formattedStatus,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return const Color(0xFFEAB308);
      case 'on_going':
        return const Color(0xFF8B5CF6);
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Icons.calendar_today;
      case 'on_going':
        return Icons.autorenew;
      case 'pending':
        return Icons.hourglass_top;
      case 'completed':
        return Icons.check;
      default:
        return Icons.info;
    }
  }
}
