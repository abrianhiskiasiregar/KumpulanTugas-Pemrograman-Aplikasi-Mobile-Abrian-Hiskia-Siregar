import 'package:flutter/material.dart';
import '../models/log_model.dart';

class LogList extends StatelessWidget {
  final List<LogModel> logs;

  const LogList({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];

        return ListTile(
          dense: true,
          leading: Icon(
            log.level == LogLevel.error ? Icons.error : Icons.info,
            color: log.color,
            size: 16,
          ),
          title: Text(
            "[${log.formattedTime}] ${log.message}",
            style: TextStyle(fontSize: 12, color: log.color),
          ),
        );
      },
    );
  }
}