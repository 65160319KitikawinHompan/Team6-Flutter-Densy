import 'package:flutter/material.dart';

class YesNoButtonGroup extends StatefulWidget {
  final bool? hasResult;
  final String patrolStatus;
  final int itemId; 
  final int zoneId; 
  final Function(int itemId, int zoneId, bool status)? onSelectionChanged; 

  const YesNoButtonGroup({
    Key? key, 
    required this.hasResult, 
    required this.patrolStatus, 
    required this.itemId,
    required this.zoneId,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  _YesNoButtonGroupState createState() => _YesNoButtonGroupState();
}

class _YesNoButtonGroupState extends State<YesNoButtonGroup> {
  String? _selected; // เก็บค่าว่า user เลือก "yes" หรือ "no" หรือยังไม่เลือก (null)

  @override
  void initState() {
    super.initState();
    // ตั้งค่าเริ่มต้นตามค่า hasReult
    if (widget.hasResult != null) {
      _selected = widget.hasResult == true ? "yes" : "no";
    } else {
      _selected = null; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildButton(
          label: "Yes",
          isSelected: _selected == "yes",
          patrolStatus: widget.patrolStatus,
          onPressed: () {
            if (widget.patrolStatus == "on_going") {
              setState(() {
                _selected = "yes";
              });
              widget.onSelectionChanged?.call(widget.itemId, widget.zoneId, true);
            };
          },
        ),
        const SizedBox(width: 12), 
        _buildButton(
          label: "No",
          isSelected: _selected == "no",
          patrolStatus: widget.patrolStatus,
          onPressed: () {
            if (widget.patrolStatus == "on_going") {
              setState(() {
                _selected = "no";
              });
              widget.onSelectionChanged?.call(widget.itemId, widget.zoneId, false);
            }
          },
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
    required String patrolStatus,
  }) {
    // กำหนดสีพื้นหลังตามสถานะ
    Color backgroundColor;
    Color foregroundColor;

  if (patrolStatus == "scheduled") {
      backgroundColor = Colors.grey[300]!; // Locked state (gray)
      foregroundColor = Colors.grey[600]!; // Darker gray for text and icon
    } else if (isSelected) {
      backgroundColor = (label == "Yes") ? Colors.green : Colors.red; // Selected state
      foregroundColor = Colors.white; // White text and icon for better contrast
    } else {
      backgroundColor = Colors.grey[300]!; // Default gray color
      foregroundColor = const Color(0xFF333840); // Default text and icon color
    }
    IconData? leadingIcon;
    if (label == "Yes") {
      leadingIcon = Icons.check; 
    } else if (label == "No") {
      leadingIcon = Icons.close; 
    }

    return SizedBox(
      width: 133.5,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600, 
            fontSize: 18,
          ),
          foregroundColor: const Color(0xFF333840),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 20),
              const SizedBox(width: 4),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}