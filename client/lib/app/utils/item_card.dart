import 'package:flutter/material.dart';
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
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 28,
                  color: Colors.black87,
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
                color: const Color(0xFF333840),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Zone',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600, // semibold
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.zoneName,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.normal, // regular
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // icon supervisor w=24,h=24 สีขาว
                      const Icon(
                        Icons.supervisor_account,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 6),

                      const Text(
                        'Supervisor',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
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
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.white,
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
                    onSelectionChanged: (itemId, zoneId, status) {
                      setState(() {
                        _selected = status ? "yes" : "no"; 
                      });
                      widget.onSelectionChanged?.call(itemId, zoneId, status); 
                    },
                  ),
                  const SizedBox(height: 6),
                  if (_selected == "no")
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
                              controller.postComment(_commentController.text, widget.patrolResultId, widget.supervisorId);
                              _commentController.clear();
                            } 
                          },
                          child: const Text("Send"),
                        ),
                      ],
                    ),
                  )
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