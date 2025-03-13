import 'package:flutter/material.dart';
import 'package:flutter_densy_project/app/controllers/theme_controller.dart';
import 'package:get/get.dart';

class SubmitButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final ThemeController themeController;

  const SubmitButton({
    super.key, 
    required this.title, 
    required this.onPressed, 
    required this.themeController
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: themeController.isDarkMode.value ? Colors.black : Colors.grey), 
            ),
            minimumSize: Size(double.infinity, 55), 
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(fontSize: 16, color: themeController.isDarkMode.value ? Colors.black : Colors.white),
          ),
        ),
      );
    });
  }
}
class NextPageButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final ThemeController themeController; 

  const NextPageButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.themeController, 
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment(2.5, 0.5),
            colors: <Color>[
              Colors.redAccent,
              Colors.blueAccent,
            ],
            tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: themeController.isDarkMode.value ? Colors.black : Colors.grey,
              ),
            ),
            minimumSize: const Size(100, 55),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: themeController.isDarkMode.value ? Colors.black : Colors.white,
            ),
          ),
        ),
      );
    });
  }
}

class SaveButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final ThemeController themeController;

  const SaveButton({
    super.key, 
    required this.title, 
    required this.onPressed, 
    required this.themeController
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.grey), 
          ),
          minimumSize: Size(double.infinity, 55), 
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_outlined, color: themeController.isDarkMode.value ? Colors.black : Colors.white, size: 24),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(fontSize: 18, color: themeController.isDarkMode.value ? Colors.black : Colors.white),
            ),
          ],
        )
      ),
    );
  }
}
