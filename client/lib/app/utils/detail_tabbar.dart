import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/controllers/theme_controller.dart';
import 'package:get/get.dart';

final ThemeController _themeController = Get.put(ThemeController());

class DetailTabBar extends StatefulWidget {
  final Function(int) onTabChanged; // Callback when tab changes

  const DetailTabBar({Key? key, required this.onTabChanged}) : super(key: key);

  @override
  _DetailTabBarState createState() => _DetailTabBarState();
}

class _DetailTabBarState extends State<DetailTabBar> {
  int _selectedIndex = 0; // Store the index of the selected tab

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _themeController.isDarkMode.value ? Colors.grey[800] : Colors.grey[200],
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
          color: isSelected
              ? (_themeController.isDarkMode.value ? Colors.white : Color(0xFF333840))
              : (_themeController.isDarkMode.value ? Colors.grey[700] : Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? (_themeController.isDarkMode.value ? Colors.black : Colors.white)
                  : (_themeController.isDarkMode.value ? Colors.white70 : Colors.grey),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? (_themeController.isDarkMode.value ? Colors.black : Colors.white)
                    : (_themeController.isDarkMode.value ? Colors.white70 : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}