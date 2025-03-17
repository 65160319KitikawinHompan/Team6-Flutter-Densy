import 'package:flutter/material.dart';

class YesNoButtonGroup extends StatefulWidget {
  const YesNoButtonGroup({Key? key}) : super(key: key);

  @override
  _YesNoButtonGroupState createState() => _YesNoButtonGroupState();
}

class _YesNoButtonGroupState extends State<YesNoButtonGroup> {
  String?
      _selected; // เก็บค่าว่า user เลือก "yes" หรือ "no" หรือยังไม่เลือก (null)

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildButton(
          label: "Yes",
          isSelected: _selected == "yes",
          onPressed: () {
            setState(() {
              _selected = "yes";
            });
          },
        ),
        const SizedBox(width: 12), 
        _buildButton(
          label: "No",
          isSelected: _selected == "no",
          onPressed: () {
            setState(() {
              _selected = "no";
            });
          },
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    // กำหนดสีพื้นหลังตามสถานะ
    Color backgroundColor;
    if (isSelected) {
      backgroundColor = (label == "Yes") ? Colors.green : Colors.red;
    } else {
      backgroundColor = Colors.grey[300]!; 
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
