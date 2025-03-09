import 'package:flutter/material.dart';

class DetailTabBar extends StatefulWidget {
  final Function(int) onTabChanged; // Callback เมื่อเปลี่ยนแท็บ

  const DetailTabBar({Key? key, required this.onTabChanged}) : super(key: key);

  @override
  _DetailTabBarState createState() => _DetailTabBarState();
}

class _DetailTabBarState extends State<DetailTabBar> {
  int _selectedIndex = 0; // เก็บ index ของแท็บที่ถูกเลือก

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabButton(
            index: 0,
            label: "Detail",
            icon: Icons.list,
          ),
          _buildTabButton(
            index: 1,
            label: "Comment",
            icon: Icons.campaign_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({required int index, required String label, required IconData icon}) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onTabChanged(index);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF333840) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

