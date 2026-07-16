// lib/widgets/error_display.dart
import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class ErrorDisplay extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorDisplay({Key? key, required this.error, required this.onRetry})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = 'Error';
    String message = error.toString();
    IconData icon = Icons.error_outline;

    if (error is WeatherServiceException) {
      final weatherError = error as WeatherServiceException;
      message = weatherError.message;
      switch (weatherError.type) {
        case WeatherErrorType.network:
          title = 'Koneksi Bermasalah';
          icon = Icons.wifi_off;
          break;
        case WeatherErrorType.timeout:
          title = 'Waktu Habis';
          icon = Icons.timer_off;
          break;
        case WeatherErrorType.unauthorized:
          title = 'API Key Belum Aktif';
          icon = Icons.key_off;
          break;
        default:
          title = 'Terjadi Kesalahan';
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.red[400]),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
