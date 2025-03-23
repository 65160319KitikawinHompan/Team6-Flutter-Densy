import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/controllers/theme_controller.dart';
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
    final ThemeController _themeController = Get.put(ThemeController());
    
    return Obx(() {
      return Scaffold(
        backgroundColor: _themeController.isDarkMode.value
              ? Colors.grey[900]
              : Colors.grey[100],
        body: Obx(() {
          if (controller.patrolDetail.isEmpty || controller.presetsData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Patrol Name
                Text(
                  controller.presetsData["title"] ?? "No Title",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _themeController.isDarkMode.value ? Colors.white: Colors.black87),
                ),
                const SizedBox(height: 8),

                // Status Badge
                _buildStatusBadge(controller.patrolDetail["status"] ?? ""),
                const SizedBox(height: 12),

                // TabBar and Start Button
                Row(
                  children: [
                    DetailTabBar(
                      onTabChanged: (id) {
                          print("change page ${id}");
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
                            if (controller.patrolDetail["status"] == "scheduled") {
                              controller.startPatrolDetail();
                            } else  if (controller.patrolDetail["status"] == "on_going") {
                              controller.finishPatrolDetail();
                            }
                          },
                          icon: Icon(
                            _getButtonIcon(controller.patrolDetail["status"] ?? ""),
                            color: _themeController.isDarkMode.value? Colors.black : Colors.white,
                            size: 18,
                          ),
                          label: Text(
                            _getButtonText(controller.patrolDetail["status"] ?? ""),
                            style: TextStyle(
                              color: _themeController.isDarkMode.value? Colors.black : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getButtonColor(controller.patrolDetail["status"] ?? ""),
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
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.patrolDetail["patrolChecklists"]?.length ?? 0,
                    itemBuilder: (context, index) {
                      final checklist = controller.patrolDetail["patrolChecklists"]?[index];
                      final inspector = checklist["inspector"] ?? {};
                      final inspectorName = inspector["profile"]?["name"] ?? "Unknown Inspector";
                      final inspectorImage = inspector["profile"]?["image"] != null
                          ? "http://localhost:4000/uploads/${inspector["profile"]["image"]["path"]}"
                          : "https://i.pravatar.cc/300";

                      return ChecklistCard(
                        title: checklist["checklist"]["title"] ?? "Untitled Checklist",
                        inspectorName: inspectorName,
                        inspectorImage: inspectorImage,
                        statusColor: _getStatusColor(controller.patrolDetail["status"] ?? ""),
                        children: _buildItemCards(checklist["checklist"]["items"] ?? [], controller.patrolDetail["status"] ?? ""),
                      );
                    },
                  ),
                ),
                // NavBar
                CustomNavBar(),
              ],
            ),
          );
        }),
      );
    });
  }

  List<Widget> _buildItemCards(List<dynamic> items, String patrolStatus) {
    return items.map((item) {
      final itemId = item["id"];
      final resultList = controller.patrolDetail["results"] as List? ?? [];
      final result = resultList.firstWhere(
        (resultItem) => resultItem["itemId"] == itemId,
        orElse: () => null,
      );

      final status = result != null ? result["status"] : null;
      final patrolResultId = result != null ? result["id"] : null;

      final comments = result != null ? result["comments"] as List<dynamic>? ?? [] : [];

      final itemZones = item["itemZones"] ?? [];
      final zoneId = itemZones.isNotEmpty
          ? itemZones[0]["zone"]["id"] ?? -1
          : -1;

      final supervisorId = itemZones.isNotEmpty
          ? itemZones[0]["zone"]["supervisor"]["id"] ?? -1
          : -1;

      final supervisorName = itemZones.isNotEmpty
          ? itemZones[0]["zone"]["supervisor"]["profile"]["name"] ?? "Unnamed Person"
          : "Unnamed Person";

      final zoneName = itemZones.isNotEmpty
          ? itemZones[0]["zone"]["name"]
              .replaceAll('_', ' ')
              .split(' ')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' ')
          : "Unknown Zone";

      return ItemCard(
        title: item["name"] ?? "Unnamed Item",
        type: item["type"] ?? "Unknown Type",
        supervisorName: supervisorName,
        zoneName: zoneName,
        hasReult: status,
        patrolStatus: patrolStatus,
        itemId: itemId,
        zoneId: zoneId,
        patrolResultId: patrolResultId ?? 0,
        supervisorId: supervisorId,
        comments: comments, 
        onSelectionChanged: (itemId, zoneId, status) {
          controller.updateResultStatus(itemId, zoneId, status);
        },
      );
    }).toList();
  }

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

  IconData _getButtonIcon (String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Icons.autorenew;
      case 'on_going':
        return Icons.save_outlined;
      case 'pending':
        return Icons.remove_red_eye_outlined;
      case 'completed':
        return Icons.remove_red_eye_outlined;
      default:
        return Icons.info;
    }
  }

  Color _getButtonColor (String status) {
    switch (status.toLowerCase()) {
       case 'scheduled':
        return const Color(0xFF8B5CF6);
      case 'on_going':
        return const Color(0xFF8B5CF6);
      case 'pending':
        return Colors.green;
      case 'completed':
        return Colors.green;
      default:
        return Colors.green;
    }
  }

  String _getButtonText (String status) {
    switch (status.toLowerCase()) {
       case 'scheduled':
        return "Start";
      case 'on_going':
        return "Save";
      case 'pending':
        return "View";
      case 'completed':
        return "View";
      default:
        return "Default";
    }
  } 
}
