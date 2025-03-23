import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/controllers/theme_controller.dart';
import 'package:flutter_densy_project/app/modules/detail/controllers/detail_controller.dart';
import 'package:flutter_densy_project/app/utils/yes_no_button.dart';
import 'package:get/get.dart';

class ItemCard extends StatefulWidget {
  final String title;
  final String type;
  final String supervisorName;
  final String zoneName;
  final bool? hasReult;
  final String patrolStatus;
  final int itemId;
  final int zoneId;
  final Function(int itemId, int zoneId, bool status)? onSelectionChanged;
  final int patrolResultId;
  final int supervisorId;
  final List<dynamic> comments;

  const ItemCard({
    Key? key,
    required this.title,
    required this.type,
    required this.hasReult,
    required this.patrolStatus,
    required this.itemId,
    required this.zoneId,
    this.onSelectionChanged,
    required this.supervisorName,
    required this.zoneName,
    required this.patrolResultId,
    required this.supervisorId, 
    required this.comments,
  }) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool isExpanded = false;
  final TextEditingController _commentController = TextEditingController();
  String? _selected;
  final controller = Get.find<DetailController>();

  @override
  void initState() {
    super.initState();
    // Initialize the selection based on hasResult
    if (widget.hasReult != null) {
      _selected = widget.hasReult == true ? "yes" : "no";
    } else {
      _selected = null;
    }
  }

  @override
  void dispose() {
    _commentController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final variant = getItemTypeVariant(widget.type);
    final ThemeController _themeController = Get.put(ThemeController());
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.only(left: 3, top: 0, right: 16, bottom: 0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Arrow Button
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: _themeController.isDarkMode.value ? Colors.white: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 28,
                  color: _themeController.isDarkMode.value ? Colors.white: Colors.black87,
                  weight: 600,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Type Badge (เมื่อ expanded)
          if (isExpanded) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: variant['backgroundColor'],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      variant['icon'],
                      color: variant['textColor'],
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.type,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: variant['textColor'],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // กรอบสี่เหลี่ยมสีดำ (Zone + Supervisor)
            Container(
              width: 307,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _themeController.isDarkMode.value
                      ? Colors.grey[200]
                      : Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: _themeController.isDarkMode.value? Colors.black : Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Zone',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600, // semibold
                          fontSize: 16,
                          color: _themeController.isDarkMode.value ? Colors.black87 : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.zoneName,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.normal, // regular
                          fontSize: 16,
                          color: _themeController.isDarkMode.value ? Colors.black87 : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.supervisor_account,
                        color: _themeController.isDarkMode.value ? Colors.black : Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Supervisor',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: _themeController.isDarkMode.value ? Colors.black87 : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=3',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.supervisorName,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: _themeController.isDarkMode.value ? Colors.black87 : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  YesNoButtonGroup(
                    hasResult: widget.hasReult,
                    patrolStatus: widget.patrolStatus,
                    itemId: widget.itemId,
                    zoneId: widget.zoneId,
                    comments: widget.comments,
                    onSelectionChanged: (itemId, zoneId, status) {
                      setState(() {
                        _selected = status ? "yes" : "no"; // Update the selected state
                      });

                      // Check if an entry with the same itemId and zoneId already exists
                      final existingIndex = controller.startPatrolResult.indexWhere(
                        (result) => result['itemId'] == itemId && result['zoneId'] == zoneId,
                      );

                      if (existingIndex != -1) {
                        // Update the existing entry
                        controller.startPatrolResult[existingIndex]['status'] = status;
                      } else {
                        // Add a new entry
                        controller.startPatrolResult.add({
                          'itemId': itemId,
                          'zoneId': zoneId,
                          'status': status,
                        });
                      }

                      // Call the parent callback if provided
                      widget.onSelectionChanged?.call(itemId, zoneId, status);

                      // Debug prints
                      print(controller.startPatrolResult);
                      print(controller.startPatrolResult.length);
                    },
                  ),
                  const SizedBox(height: 6),
                  if (widget.comments.isNotEmpty) ...[
                    const SizedBox(height: 12), 
                    ...widget.comments.map((comment) {
                      // Format the timestamp
                      final timestamp = comment["timestamp"] != null
                          ? DateTime.parse(comment["timestamp"])
                              .toLocal()
                              .toString()
                              .split('.')[0] 
                          : "No timestamp";
                      final formattedTimestamp = timestamp != "No timestamp"
                          ? "${timestamp.split(' ')[0]} ${timestamp.split(' ')[1].substring(0, 5)}" 
                          : timestamp;

                      return Container(
                        width: 307,
                        margin: const EdgeInsets.only(bottom: 8), 
                        padding: const EdgeInsets.all(12), 
                        decoration: BoxDecoration(
                          color: _themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[700], 
                          borderRadius: BorderRadius.circular(12), 
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$formattedTimestamp\n${comment["message"] ?? "No message"}",
                              style: TextStyle(
                                color: _themeController.isDarkMode.value ? Colors.black87 : Colors.white, 
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4), 
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                  if (_selected == "no" && widget.patrolStatus != "completed")
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              hintText: "Enter your comment...",
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              final comment = _commentController.text.trim();
                              if (comment.isNotEmpty) {
                                controller.postComment(
                                  comment,
                                  widget.patrolResultId,
                                  widget.supervisorId,
                                );
                                _commentController.clear();
                              } else {
                                Get.snackbar("Error", "Please enter a comment.");
                              }
                            },
                            child: const Text("Send"),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ฟังก์ชันกำหนด Type
  Map<String, dynamic> getItemTypeVariant(String type) {
    switch (type.toLowerCase()) {
      case 'safety':
        return {
          'icon': Icons.verified_user,
          'backgroundColor': const Color(0xFF34D399).withOpacity(0.2),
          'textColor': const Color(0xFF059669)
        };
      case 'environment':
        return {
          'icon': Icons.psychology,
          'backgroundColor': const Color(0xFF93C5FD).withOpacity(0.2),
          'textColor': const Color(0xFF3B82F6)
        };
      default: // Maintenance
        return {
          'icon': Icons.build,
          'backgroundColor': const Color(0xFFDA4453).withOpacity(0.2),
          'textColor': const Color(0xFFFB0022)
        };
    }
  }
}