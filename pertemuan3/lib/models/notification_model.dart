import 'package:flutter/material.dart';

class NotificationModel {
  final String message;
  final NotificationType type;
  final DateTime timestamp;

  NotificationModel({
    required this.message,
    required this.type,
    required this.timestamp,
  });

  factory NotificationModel.info(String message) {
    return NotificationModel(
      message: message,
      type: NotificationType.info,
      timestamp: DateTime.now(),
    );
  }

  factory NotificationModel.warning(String message) {
    return NotificationModel(
      message: message,
      type: NotificationType.warning,
      timestamp: DateTime.now(),
    );
  }

  factory NotificationModel.error(String message) {
    return NotificationModel(
      message: message,
      type: NotificationType.error,
      timestamp: DateTime.now(),
    );
  }

  Color get color {
    switch (type) {
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.error:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (type) {
      case NotificationType.info:
        return Icons.info;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.error:
        return Icons.error;
    }
  }
}

enum NotificationType { info, warning, error }