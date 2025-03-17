import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/modules/detail/controllers/detail_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_densy_project/app/utils/navbar.dart';
import 'package:flutter_densy_project/app/utils/detail_tabbar.dart'; // Import ไฟล์ที่สร้าง

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final patrol = Get.arguments; // รับข้อมูลจากหน้า PatrolView

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // ชื่อของ Patrol
            Text(
              patrol["preset"]["title"],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // สถานะ (ใช้สีเดียวกับ patrol_card)
            _buildStatusBadge(patrol["status"]),

            const SizedBox(height: 12),

            // TabBar + Start Button (ไม่ให้ขยายเกินขนาดจริง)
            Row(
              children: [
                // TabBar ชิดซ้าย
                DetailTabBar(
                  onTabChanged: (_) {
                 
                  },
                ),

                // ใช้ Spacer() แทน Expanded เพื่อให้ดันปุ่ม Start ไปชิดขวา
                const Spacer(),

                // ปุ่ม Start (ตั้งค่าให้สูงเท่ากับ TabBar)
                Padding(
                  padding:
                      const EdgeInsets.only(right: 0), // ระยะห่างจากขอบขวา
                  child: SizedBox(
                    height: 48,
                    width: 100, // กำหนดความสูงให้เท่ากับ TabBar
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // ทำสิ่งที่ต้องการเมื่อกดปุ่ม Start
                      },
                      icon: const Icon(Icons.autorenew,
                          color: Colors.white, size: 18),
                      label: const Text("Start",
                          style: TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.bold)),
                          
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF3B82F6), // สีฟ้า Primary
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(24), // ให้โค้งเหมือน TabBar
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
                      children: _buildItemCards(checklist["checklist"]["items"] ?? []),
                      statusColor: _getStatusColor(patrol["status"]),
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

  List<Widget> _buildItemCards(List<dynamic> items) {
    return items.map((item) {
      return ItemCard(
        title: item["name"] ?? "Unnamed Item",
        type: item["type"] ?? "Unknown Type",
      );
    }).toList();
  }


  // ✅ ฟังก์ชันสร้างปุ่ม Start
  Widget _buildStartButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // กำหนดให้ทำอะไรเมื่อกด Start
      },
      icon: const Icon(Icons.autorenew, color: Colors.white),
      label: const Text(
        "Start",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3B82F6), // สีฟ้า Primary
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // ✅ ฟังก์ชันสร้าง Badge สถานะ
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
                fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
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
