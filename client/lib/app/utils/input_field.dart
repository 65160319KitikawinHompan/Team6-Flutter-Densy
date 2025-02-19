import 'package:flutter/material.dart';
class InputTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;

  const InputTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false, // Default: not hiding text
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText, // Hide text for password fields
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}

class DateSelectionField extends StatefulWidget {
  const DateSelectionField({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DateSelectionFieldState createState() => _DateSelectionFieldState();
}

class _DateSelectionFieldState extends State<DateSelectionField> {
  String dateSelected = "";

  Future<void> selectDate(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      firstDate: DateTime(1950), 
      lastDate: DateTime.now(), 
      initialDate: DateTime.now(),
    );
    if (selected != null) {
      setState(() {
        dateSelected = "${selected.day}/${selected.month}/${selected.year}"; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "วัน/เดือน/ปีเกิด",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => selectDate(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 25.0,
                ),
                const SizedBox(width: 8),
                Text(
                  dateSelected.isEmpty ? "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}" : dateSelected, 
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}