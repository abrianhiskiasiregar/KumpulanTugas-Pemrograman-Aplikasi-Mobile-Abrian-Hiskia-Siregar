class WeatherMessage {
  final String city;
  final String condition;
  final int temperature;
  final DateTime time;

  WeatherMessage({
    required this.city,
    required this.condition,
    required this.temperature,
    required this.time,
  });
}
