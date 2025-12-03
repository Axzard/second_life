import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  final String title;
  final String time;
  final String type;

  const ActivityItem({
    super.key,
    required this.title,
    required this.time,
    required this.type,
  });

  IconData get icon {
    switch (type) {
      case "user":
        return Icons.person_outline;
      case "product":
        return Icons.inventory_2_outlined;
      case "alert":
        return Icons.warning_amber;
      default:
        return Icons.block;
    }
  }

  Color get iconColor {
    switch (type) {
      case "user":
        return Colors.blue;
      case "product":
        return Colors.green;
      case "alert":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor, size: 20),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
            const SizedBox(height: 4),
            Text(time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                )),
          ],
        ),
      ],
    );
  }
}
