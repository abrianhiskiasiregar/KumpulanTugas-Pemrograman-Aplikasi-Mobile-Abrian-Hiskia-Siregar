import 'package:flutter/material.dart';
import '../models/weather_message.dart';

class WeatherCard extends StatelessWidget {
  final WeatherMessage weather;

  const WeatherCard({super.key, required this.weather});

  IconData getWeatherIcon(String condition) {
    switch (condition) {
      case 'Cerah':
        return Icons.wb_sunny;

      case 'Hujan':
        return Icons.cloudy_snowing;

      case 'Berawan':
        return Icons.cloud;

      default:
        return Icons.thunderstorm;
    }
  }

  String formatTime(DateTime time) {
    String hour = time.hour.toString().padLeft(2, '0');

    String minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey,

          child: Text(
            '${weather.temperature}°',

            style: const TextStyle(color: Colors.white),
          ),
        ),

        title: Text(weather.city),

        subtitle: Text('${weather.condition} • ${formatTime(weather.time)}'),

        trailing: Icon(getWeatherIcon(weather.condition), color: Colors.orange),
      ),
    );
  }
}
