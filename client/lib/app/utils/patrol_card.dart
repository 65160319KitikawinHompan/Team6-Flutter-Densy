import 'package:flutter/material.dart';

class NewPatrolButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NewPatrolButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 154,
        height: 100,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFC16975), // สีเริ่มต้น (Start Color)
              Color(0xFFFB0023), // สีสิ้นสุด (End Color)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.note_add_outlined,
            color: Colors.white,
            size: 80,
          ),
        ),
      ),
    );
  }
}


class PatrolCard extends StatelessWidget {
  final String status;
  final DateTime date;
  final String presetTitle;
  final String inspectorAvatarUrl;

  const PatrolCard({
    Key? key,
    required this.status,
    required this.date,
    required this.presetTitle,
    required this.inspectorAvatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

    return Container(
      width: 154, // ขนาดคงที่เท่ากับ NewPatrolButton
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getStatusIcon(status),
                  color: _getStatusColor(status),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // วันที่
          Text(
            formattedDate,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          // ชื่อ Preset
          Text(
            presetTitle,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          // Inspector: แสดงข้อความ "Inspector" แล้ว Avatar ของ Inspector
          Row(
            children: [
              const Text(
                'Inspector',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              CircleAvatar(
                backgroundImage: NetworkImage(inspectorAvatarUrl, scale: 1.0),
                radius: 10,
              ),
            ],
          ),
        ],
      ),
    );
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
}
