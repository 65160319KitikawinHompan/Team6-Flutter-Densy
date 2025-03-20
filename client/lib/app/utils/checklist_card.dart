import 'package:flutter/material.dart';

class ChecklistCard extends StatefulWidget {
  final String title;
  final String inspectorName;
  final String inspectorImage;
  final List<Widget>? children; 
  final Color statusColor;

  const ChecklistCard({
    Key? key,
    required this.title,
    required this.inspectorName,
    required this.inspectorImage,
    this.children, 
    required this.statusColor, 
  }) : super(key: key);

  @override
  _ChecklistCardState createState() => _ChecklistCardState();
}

class _ChecklistCardState extends State<ChecklistCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      margin: const EdgeInsets.symmetric(vertical: 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: isExpanded
            ? LinearGradient(
                colors: [const Color(0xFFFFFFFF), widget.statusColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
        color: isExpanded ? null : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title และ Icon สำหรับ Expand/Collapse
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                //  Icon Expand/Collapse
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 32,
                  color: Colors.black87,
                  weight: 600,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Inspector Section (แสดงเมื่อ Expanded)
          if (isExpanded) ...[
            Row(
              children: [
                const Icon(Icons.person_outline, color: Colors.grey, size: 20),
                const SizedBox(width: 6),
                const Text(
                  'Inspector',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.inspectorImage),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.inspectorName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),

            // แสดง children เมื่อ Expanded
            if (widget.children != null) ...widget.children!,
          ],
        ],
      ),
    );
  }
}
