// lib/models/weather_model.dart
class WeatherModel {
  final String city;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final DateTime lastUpdated;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'] ?? 'Tidak Diketahui',
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      condition: _translateCondition(json['weather'][0]['main'] ?? ''),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: ((json['wind']['speed'] ?? 0) * 3.6).toDouble(),
      lastUpdated: DateTime.now(),
    );
  }

  static String _translateCondition(String engCondition) {
    switch (engCondition.toLowerCase()) {
      case 'clear':
        return 'Cerah';
      case 'clouds':
        return 'Berawan';
      case 'rain':
      case 'drizzle':
        return 'Hujan Ringan';
      case 'thunderstorm':
        return 'Badai';
      default:
        return 'Berawan';
    }
  }

  String get iconEmoji {
    switch (condition) {
      case 'Cerah':
        return '☀️';
      case 'Berawan':
        return '☁️';
      case 'Hujan Ringan':
        return '🌦️';
      case 'Hujan Lebat':
        return '🌧️';
      case 'Badai':
        return '⛈️';
      default:
        return '🌡️';
    }
  }
}
