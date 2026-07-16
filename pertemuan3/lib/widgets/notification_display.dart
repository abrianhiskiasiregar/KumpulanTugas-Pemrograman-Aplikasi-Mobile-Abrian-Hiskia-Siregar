import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationDisplay extends StatelessWidget {
  final NotificationModel? notification; // HARUS sama

  const NotificationDisplay({super.key, this.notification});

  @override
  Widget build(BuildContext context) {
    if (notification == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("Belum ada notifikasi"),
        ),
      );
    }

    return Card(
      color: notification!.color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(notification!.icon, color: notification!.color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                notification!.message,
                style: TextStyle(color: notification!.color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}