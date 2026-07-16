import 'dart:async';
import '../models/weather_message.dart';

class WeatherStreamService {
  final StreamController<List<WeatherMessage>> _controller =
      StreamController.broadcast();

  final List<WeatherMessage> _messages = [];

  Timer? _timer;

  Stream<List<WeatherMessage>> get weatherStream => _controller.stream;

  void startAutoWeather() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final data = WeatherMessage(
        city: _cities[timer.tick % _cities.length],

        condition: _conditions[timer.tick % _conditions.length],

        temperature: 24 + timer.tick,

        time: DateTime.now(),
      );

      _messages.insert(0, data);

      _controller.add(_messages);
    });
  }

  void addCustomWeather(String text) {
    final custom = WeatherMessage(
      city: text,

      condition: 'Input User',

      temperature: 30,

      time: DateTime.now(),
    );

    _messages.insert(0, custom);

    _controller.add(_messages);
  }

  void dispose() {
    _timer?.cancel();

    _controller.close();
  }

  final List<String> _cities = ['Medan', 'Jakarta', 'Bandung', 'Surabaya'];

  final List<String> _conditions = ['Cerah', 'Hujan', 'Berawan', 'Badai'];
}
