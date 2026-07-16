import 'package:flutter/material.dart';

class LogModel {
  final String message;
  final LogLevel level;
  final DateTime timestamp;

  LogModel(this.message, this.level, this.timestamp);

  factory LogModel.info(String message) {
    return LogModel(message, LogLevel.info, DateTime.now());
  }

  factory LogModel.error(String message) {
    return LogModel(message, LogLevel.error, DateTime.now());
  }

  String get formattedTime {
    return '${timestamp.hour}:${timestamp.minute}:${timestamp.second}';
  }

  Color get color {
    switch (level) {
      case LogLevel.info:
        return Colors.black;
      case LogLevel.error:
        return Colors.red;
    }
  }
}

enum LogLevel { info, error }